import XCTest
import Alamofire
@testable import NetworkService

class ErrorServiceTests: XCTestCase {
    
    // Добавить тесты при обновлении
    // словаря ошибок NetworkConfigurable.errorMessages
    func testHandleBadRequestError() {
        // Given
        let error = AFError.responseValidationFailed(reason: .unacceptableStatusCode(code: 400))
        // When
        let handledError = ErrorService.handle(error: error)
        // Then
        XCTAssertEqual(handledError.localizedDescription, "Bad Request")
    }
    
    func testHandleUnauthorizedError() {
        // Given
        let error = AFError.responseValidationFailed(reason: .unacceptableStatusCode(code: 401))
        // When
        let handledError = ErrorService.handle(error: error)
        // Then
        XCTAssertEqual(handledError.localizedDescription, "Unauthorized")
    }
    
    func testHandleForbiddenError() {
        // Given
        let error = AFError.responseValidationFailed(reason: .unacceptableStatusCode(code: 403))
        // When
        let handledError = ErrorService.handle(error: error)
        // Then
        XCTAssertEqual(handledError.localizedDescription, "Forbidden")
    }
    
    func testHandleNotFoundError() {
        // Given
        let error = AFError.responseValidationFailed(reason: .unacceptableStatusCode(code: 404))
        // When
        let handledError = ErrorService.handle(error: error)
        // Then
        XCTAssertEqual(handledError.localizedDescription, "Not Found")
    }
    
    func testHandleUnknownError() {
        // Given
        let error = AFError.explicitlyCancelled
        // When
        let handledError = ErrorService.handle(error: error)
        // Then
        XCTAssertEqual(handledError.localizedDescription, "Unknown Error")
    }
}
