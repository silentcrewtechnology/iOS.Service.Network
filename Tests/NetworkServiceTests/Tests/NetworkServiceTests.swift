import XCTest
import Alamofire
@testable import NetworkService

class NetworkServiceTests: XCTestCase {
    
    var networkService: NetworkService!
    var mockConfig: NetworkConfigurable!
    var mockLogger: LoggerProtocol.Type!
    var mockErrorHandler: ErrorHandling.Type!
    var mockSession: Session!

    override func setUp() {
        super.setUp()
        mockConfig = MockNetworkConfig()
        mockLogger = MockLogger.self
        mockErrorHandler = MockErrorService.self
        mockSession = createMockSession()
        networkService = NetworkService(config: mockConfig, logger: mockLogger, errorHandler: mockErrorHandler, session: mockSession)
    }

    override func tearDown() {
        networkService = nil
        mockSession = nil
        mockConfig = nil
        super.tearDown()
    }

    private func createMockSession() -> Session {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self]
        return Session(configuration: configuration)
    }

    func testRequestSuccess() {
        let expectation = self.expectation(description: "Successful request")
        
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            let data = "{\"testField\":\"testValue\"}".data(using: .utf8)!
            return (response, data)
        }
        
        networkService.request(
            endpoint: "testEndpoint",
            method: .get,
            parameters: nil,
            encoder: URLEncoding.default,
            headers: nil,
            progress: nil,
            success: { (response: MockResponseModel) in
                XCTAssertEqual(response.testField, "testValue")
                expectation.fulfill()
            },
            failure: { error in
                XCTFail("Request failed with error: \(error)")
            })
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testRequestFailure() {
        let expectation = self.expectation(description: "Failed request")
        
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 401, httpVersion: nil, headerFields: nil)!
            let data = Data()
            return (response, data)
        }
        
        networkService.request(
            endpoint: "testEndpoint",
            method: .get,
            parameters: nil,
            encoder: URLEncoding.default,
            headers: nil,
            progress: nil,
            success: { (response: MockResponseModel) in
                XCTFail("Request should have failed")
            },
            failure: { error in
                XCTAssertEqual(error.localizedDescription, "Unauthorized")
                expectation.fulfill()
            })
        
        waitForExpectations(timeout: 5, handler: nil)
    }
}
