import Foundation

public struct ResultResponse<T: Decodable>: Decodable {
    public var result: T?
    public var success: Bool
    public var error: String?
    public var errorCode: Int?
    
    enum CodingKeys: String, CodingKey {
        case result = "Result"
        case success = "Success"
        case error = "Error"
        case errorCode = "ErrorCode"
    }
}
