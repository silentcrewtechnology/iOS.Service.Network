import Foundation
import Alamofire
@testable import NetworkService

class MockErrorService: ErrorHandling {
    static func handle(error: AFError) -> Error {
        return NSError(domain: "MockNetworkService", code: 401, userInfo: [NSLocalizedDescriptionKey: "Unauthorized"])
    }
}
