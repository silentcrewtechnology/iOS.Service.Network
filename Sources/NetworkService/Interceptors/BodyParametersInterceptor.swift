import Foundation
import Alamofire

open class BodyParametersInterceptor: RequestInterceptor {
    
    public var parameters: Parameters?
    
    public init(
        parameters: Parameters? = nil
    ) {
        self.parameters = parameters
    }
    
    open func adapt(
        _ urlRequest: URLRequest,
        for session: Session,
        completion: @escaping (Result<URLRequest, any Error>) -> Void
    ) {
        do {
            let newRequest = try JSONEncoding.default.encode(urlRequest, with: parameters)
            completion(.success(newRequest))
        } catch {
            completion(.failure(error))
        }
    }
}
