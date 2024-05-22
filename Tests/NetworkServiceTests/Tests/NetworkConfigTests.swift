import XCTest
import Alamofire
@testable import NetworkService

class NetworkConfigTests: XCTestCase {

    var config: NetworkConfig!
    
    override func setUp() {
        super.setUp()
        config = NetworkConfig.shared
    }

    override func tearDown() {
        config = nil
        super.tearDown()
    }
    
    func testCreateTrustManager() {
        let trustManager = config.createTrustManager()
        XCTAssertNotNil(trustManager)
    }
    
    func testAddHeaders() {
        config.addDefaultHeader(field: "Authorization", value: "Bearer token")
        XCTAssertEqual(config.defaultHeaders["Authorization"], "Bearer token")
    }
    
    func testRemoveHeaders() {
        config.removeDefaultHeader(field: "Authorization")
        XCTAssertNil(config.defaultHeaders["Authorization"])
    }
}
