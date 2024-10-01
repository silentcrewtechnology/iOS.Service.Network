//
//  UrlAndBodyParametersInterceptor.swift
//
//
//  Created by user on 01.10.2024.
//

import Foundation
import Alamofire

public final class UrlAndBodyParametersInterceptor: RequestInterceptor {
    
    // MARK: - Private properties
    
    private let bodyParameters: Parameters?
    
    // MARK: - Life cycle
    
    public init(bodyParameters: Parameters?) {
        self.bodyParameters = bodyParameters
    }
    
    // MARK: - Methods
    
    public func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, any Error>) -> Void) {
        if let postData = (try? JSONSerialization.data(withJSONObject: bodyParameters ?? [], options: [])) {
            var newRequest = urlRequest
            newRequest.httpBody = postData
            completion(.success(newRequest))
        } else {
            completion(.success(urlRequest))
        }
    }
}
