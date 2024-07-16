//
//  JSONDecoderService.swift
//
//
//  Created by firdavs on 16.07.2024.
//

import Foundation

public struct JSONDecoderService {
    private let decoder = JSONDecoder()
    public var keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy
    
    public init(
        keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy
    ){
        self.keyDecodingStrategy = keyDecodingStrategy
    }
    
    public func decode<T: Decodable>(jsonType: T.Type, data: Data?) -> T? {
        guard let data = data else { return nil }
        do {
            self.decoder.keyDecodingStrategy = keyDecodingStrategy
            let json = try self.decoder.decode(T.self, from: data)
            return json
            //return error
        } catch let error {
            let jsonString = String(data: data, encoding: .utf8) ?? " Error JsonString"
            print(error.localizedDescription, "Error parse JSONDecode \(jsonString) string convert")
            return nil
        }
    }
}

extension JSONDecoder.KeyDecodingStrategy {
    
    private struct AnyKey: CodingKey {
        var stringValue: String
        var intValue: Int?
        
        init(stringValue: String) {
            self.stringValue = stringValue
            self.intValue = nil
        }
        
        init(intValue: Int) {
            self.stringValue = String(intValue)
            self.intValue = intValue
        }
    }
    
    static var convertFromCapitalizedCamelCase: Self {
        return .custom { codingKeys in
            
            guard let key = codingKeys.last else {
                assert(false, "empty coding keys while decoding from capitalized camelcase")
                return AnyKey(stringValue: "")
            }
            
            if let firstChar = key.stringValue.first {
                let i = key.stringValue.startIndex
                
                var stringValue = key.stringValue
                stringValue.replaceSubrange(
                    i...i,
                    with: String(firstChar).lowercased()
                )
                
                return AnyKey(stringValue: stringValue)
            }
            return key
        }
    }
}

