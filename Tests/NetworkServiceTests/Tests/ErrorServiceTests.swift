import XCTest
import Alamofire
@testable import NetworkService

class ErrorServiceTests: XCTestCase {
    
    // Добавить тесты при обновлении
    // словаря ошибок NetworkConfigurable.errorMessages
    func testHandleBadRequestError() {
        let error = AFError.responseValidationFailed(reason: .unacceptableStatusCode(code: 400))
        let handledError = ErrorService.handle(error: error)
        
        XCTAssertEqual(handledError.localizedDescription, "Bad Request")
    }
    
    func testHandleUnauthorizedError() {
        let error = AFError.responseValidationFailed(reason: .unacceptableStatusCode(code: 401))
        let handledError = ErrorService.handle(error: error)
        
        XCTAssertEqual(handledError.localizedDescription, "Unauthorized")
    }
    
    func testHandleForbiddenError() {
        let error = AFError.responseValidationFailed(reason: .unacceptableStatusCode(code: 403))
        let handledError = ErrorService.handle(error: error)
        
        XCTAssertEqual(handledError.localizedDescription, "Forbidden")
    }
    
    func testHandleNotFoundError() {
        let error = AFError.responseValidationFailed(reason: .unacceptableStatusCode(code: 404))
        let handledError = ErrorService.handle(error: error)
        
        XCTAssertEqual(handledError.localizedDescription, "Not Found")
    }
    
    func testHandleUnknownError() {
        let error = AFError.explicitlyCancelled
        let handledError = ErrorService.handle(error: error)
        
        XCTAssertEqual(handledError.localizedDescription, "Unknown Error")
    }
}
