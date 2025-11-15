import Alamofire
import Foundation

public protocol ErrorHandling {
    static func handle(error: AFError) -> Error
}

public class ErrorService: ErrorHandling {
    public static func handle(error: AFError) -> Error {
        if let responseCode = error.responseCode,
           let errorMessage = NetworkConfig.shared.errorMessages[responseCode] {
            return NSError(domain: "NetworkService", code: responseCode, userInfo: [NSLocalizedDescriptionKey: errorMessage])
        } else {
            return NSError(domain: "NetworkService", code: -1, userInfo: [NSLocalizedDescriptionKey: NetworkConfig.shared.unknownError])
        }
    }
}
