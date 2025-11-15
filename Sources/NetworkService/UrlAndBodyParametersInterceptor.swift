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
    
    public func adapt(
        _ urlRequest: URLRequest,
        for session: Session,
        completion: @escaping (Result<URLRequest, any Error>) -> Void
    ) {
        do {
            let newRequest = try JSONEncoding.default.encode(urlRequest, with: bodyParameters)
            completion(.success(newRequest))
        } catch {
            completion(.failure(NSError()))
        }
    }
}
