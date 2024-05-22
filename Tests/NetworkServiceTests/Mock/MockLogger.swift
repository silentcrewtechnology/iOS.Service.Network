import Foundation
import Alamofire
@testable import NetworkService

class MockLogger: LoggerProtocol {
    static func log(request: DataRequest, dataResponse: DataResponse<Data, AFError>) {
        // Mock logging
    }
    
    static func logDecoded<T>(_ model: T) where T : Decodable {
        // Mock logging
    }
}
