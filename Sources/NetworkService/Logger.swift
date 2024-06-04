import Foundation
import Alamofire

public protocol LoggerProtocol {
    static func log(request: DataRequest, dataResponse: DataResponse<Data, AFError>)
    static func logDecoded<T: Decodable>(_ model: T)
}

public class Logger: LoggerProtocol {
    public static func log(request: DataRequest, dataResponse: DataResponse<Data, AFError>) {
        print("\n--- Request URL: \(request.request?.url?.absoluteString ?? "Unknown URL") ---")
        print("Method: \(request.request?.httpMethod ?? "Unknown Method")")
        print("Headers: \(request.request?.allHTTPHeaderFields ?? [:])")
        print("Request Body: \(String(data: request.request?.httpBody ?? Data(), encoding: .utf8) ?? "No body")")
        
        if let statusCode = dataResponse.response?.statusCode {
            print("Status Code: \(statusCode)")
        }
        if let data = dataResponse.data, let jsonString = String(data: data, encoding: .utf8) {
            print("Response JSON: \(jsonString)")
        } else {
            print("Response Data: No valid JSON data")
        }
    }
    
    public static func logDecoded<T: Decodable>(_ model: T) {
        print("\nDecoded Model: \(model)")
    }
}
