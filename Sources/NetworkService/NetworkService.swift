import Alamofire
import Foundation

public typealias SuccessHandler<T> = ((T) -> Void)
public typealias ErrorHandler = ((Error) -> Void)
public typealias ProgressHandler = ((Progress) -> Void)

public protocol NetworkServiceProtocol {
    
    func request<T: Decodable>(
        keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy,
        endpoint: String,
        method: HTTPMethod,
        parameters: Parameters?,
        encoder: ParameterEncoding,
        headers: HTTPHeaders?,
        progress: ProgressHandler?,
        success: @escaping SuccessHandler<T>,
        failure: @escaping ErrorHandler
    ) -> DataRequest
}

public class NetworkService: NetworkServiceProtocol {
    
    private let session: Session
    private let config: NetworkConfigurable
    private let logger: LoggerProtocol.Type
    private let errorHandler: ErrorHandling.Type
    
    public init(
        config: NetworkConfigurable = NetworkConfig.shared,
        logger: LoggerProtocol.Type = Logger.self,
        errorHandler: ErrorHandling.Type = ErrorService.self,
        session: Session? = nil
    ) {
        self.config = config
        self.logger = logger
        self.errorHandler = errorHandler
        
        // Конфигурация URLSession
        let configuration = URLSessionConfiguration.af.default
        configuration.timeoutIntervalForRequest = config.timeoutInterval
        
        // Управление доверием сервера
        let serverTrustManager = config.createTrustManager()
        
        // Инициализация сессии с управлением доверием
        self.session = session ?? Session(configuration: configuration, serverTrustManager: serverTrustManager)
    }
    
    /// Пробуем декодировать полученную `Data`, иначе вызов `failure`.
    @discardableResult
    public func request<T: Decodable>(
        keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys,
        endpoint: String,
        method: HTTPMethod = .get,
        parameters: Parameters? = nil,
        encoder: ParameterEncoding = URLEncoding.default,
        headers: HTTPHeaders? = nil,
        progress: ProgressHandler? = nil,
        success: @escaping SuccessHandler<T>,
        failure: @escaping ErrorHandler
    ) -> DataRequest {
        return requestData(
            endpoint: endpoint,
            method: method,
            parameters: parameters,
            encoder: encoder,
            headers: headers,
            progress: progress,
            success: { [weak self] data in
                guard let self else { return }
                do {
                    let decoderService = JSONDecoder()
                    decoderService.keyDecodingStrategy = keyDecodingStrategy
                    let decoded = try decoderService.decode(T.self, from: data)
                    logger.logDecoded(decoded)
                    DispatchQueue.main.async {
                        success(decoded)
                    }
                } catch {
                    DispatchQueue.main.async {
                        failure(error)
                    }
                }
            },
            failure: failure
        )
    }
    
    /// Получаем Data, если не было ошибок в HTTP ответе.
    @discardableResult
    public func requestData(
        endpoint: String,
        method: HTTPMethod = .get,
        parameters: Parameters? = nil,
        encoder: ParameterEncoding = URLEncoding.default,
        headers: HTTPHeaders? = nil,
        progress: ProgressHandler? = nil,
        success: @escaping SuccessHandler<Data>,
        failure: @escaping ErrorHandler
    ) -> DataRequest {
        let finalHeaders = createHeaders(additionalHeaders: headers)
        let request = session.request(
            config.baseURL.appendingPathComponent(endpoint),
            method: method,
            parameters: parameters,
            encoding: encoder,
            headers: finalHeaders
        ).validate()
        
        let queue = DispatchQueue(label: "background.queue", qos: .background)
        return request.responseData(queue: queue) { [weak self] response in
            guard let self else { return }
            logger.log(request: request, dataResponse: response)
            switch response.result {
            case .success(let data):
                DispatchQueue.main.async {
                    success(data)
                }
            case .failure(let error):
                if error.isExplicitlyCancelledError { return }
                DispatchQueue.main.async {
                    failure(self.errorHandler.handle(error: error))
                }
            }
        }
    }
    
    // MARK: Слияние предопределённых заголовков с входящими
    private func createHeaders(additionalHeaders: HTTPHeaders?) -> HTTPHeaders? {
        var finalHeaders = config.defaultHeaders
        if let additionalHeaders = additionalHeaders {
            for header in additionalHeaders {
                finalHeaders.add(header)
            }
        }
        return finalHeaders
    }
}
