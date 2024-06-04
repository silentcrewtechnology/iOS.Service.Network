import Alamofire
import Foundation

typealias SuccessHandler<T> = ((T) -> Void)
typealias ErrorHandler = ((Error) -> Void)
typealias ProgressHandler = ((Progress) -> Void)

class NetworkService {
    static let shared = NetworkService()
    
    private let session: Session
    
    init(config: NetworkConfig = NetworkConfig.shared) {
        // Конфигурация URLSession
        let configuration = URLSessionConfiguration.af.default
        configuration.timeoutIntervalForRequest = config.timeoutInterval
        
        // Управление доверием сервера
        let serverTrustManager = config.createTrustManager()
        
        // Инициализация сессии с управлением доверием
        session = Session(configuration: configuration, serverTrustManager: serverTrustManager)
    }
    
    @discardableResult
    func request<T: Decodable>(
        endpoint: String,
        method: HTTPMethod = .get,
        parameters: Parameters? = nil,
        encoder: ParameterEncoding = URLEncoding.default,
        headers: HTTPHeaders? = nil,
        progress: ProgressHandler? = nil,
        success: @escaping SuccessHandler<T>,
        failure: @escaping ErrorHandler
    ) -> DataRequest {
        let finalHeaders = createHeaders(additionalHeaders: headers)
        
        let request = session.request(
            NetworkConfig.shared.baseURL.appendingPathComponent(endpoint),
            method: method,
            parameters: parameters,
            encoding: encoder,
            headers: finalHeaders
        )
            .validate()
        
        return request.responseData { response in
            DispatchQueue.main.async {
                Logger.log(request: request, dataResponse: response)
                
                switch response.result {
                case .success(let data):
                    do {
                        let decoded = try JSONDecoder().decode(T.self, from: data)
                        Logger.logDecoded(decoded)
                        success(decoded)
                    } catch {
                        failure(error)
                    }
                case .failure(let error):
                    failure(ErrorService.handle(error: error))
                }
            }
        }
    }
    
    
    // MARK: Слияние предопределённых заголовков с входящими
    private func createHeaders(additionalHeaders: HTTPHeaders?) -> HTTPHeaders? {
        var finalHeaders = NetworkConfig.shared.defaultHeaders
        if let additionalHeaders = additionalHeaders {
            for header in additionalHeaders {
                finalHeaders.add(header)
            }
        }
        return finalHeaders
    }
}
