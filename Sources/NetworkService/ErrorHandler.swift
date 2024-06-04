import Alamofire
import Foundation

protocol ErrorHandling {
    static func handle(error: AFError) -> Error
}

class ErrorService: ErrorHandling {
    static func handle(error: AFError) -> Error {
        if let responseCode = error.responseCode,
           let errorMessage = NetworkConfig.shared.errorMessages[responseCode] {
            return NSError(domain: "NetworkService", code: responseCode, userInfo: [NSLocalizedDescriptionKey: errorMessage])
        } else {
            return NSError(domain: "NetworkService", code: -1, userInfo: [NSLocalizedDescriptionKey: NetworkConfig.shared.unknownError])
        }
    }
}
