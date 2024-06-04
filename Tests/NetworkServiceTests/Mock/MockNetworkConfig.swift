import Alamofire
import Foundation
@testable import NetworkService

class MockNetworkConfig: NetworkConfigurable {
    var baseURL: URL = URL(string: "https://mockapi.com")!
    var timeoutInterval: TimeInterval = 30
    var errorMessages: [Int : String] = [401: "Unauthorized"]
    var unknownError: String = "Unknown Error"
    var defaultHeaders: HTTPHeaders = ["Content-Type": "application/json"]

    func createTrustManager() -> ServerTrustManager {
        return ServerTrustManager(evaluators: ["mockapi.com": DisabledTrustEvaluator()])
    }
    
    func addDefaultHeader(field: String, value: String) {
        defaultHeaders.add(name: field, value: value)
    }
    
    func removeDefaultHeader(field: String) {
        defaultHeaders.remove(name: field)
    }
}
