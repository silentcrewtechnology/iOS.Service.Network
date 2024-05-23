import XCTest
import Alamofire
@testable import NetworkService

class NetworkConfigTests: XCTestCase {
    // Given
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
        // When
        let trustManager = config.createTrustManager()
        // Then
        XCTAssertNotNil(trustManager)
    }
    
    func testAddHeaders() {
        // When
        config.addDefaultHeader(field: "Authorization", value: "Bearer token")
        // Then
        XCTAssertEqual(config.defaultHeaders["Authorization"], "Bearer token")
    }
    
    func testRemoveHeaders() {
        // When
        config.removeDefaultHeader(field: "Authorization")
        // Then
        XCTAssertNil(config.defaultHeaders["Authorization"])
    }
}
