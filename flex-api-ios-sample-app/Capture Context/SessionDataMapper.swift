//
//  SessionDataMapper.swift
//  flex-api-ios-sample-app
//
//  Created by Rakesh Ramamurthy on 17/03/21.
//

import Foundation

internal final class SessionDataMapper {
    private struct Root: Decodable {
        let keyId: String
    }
    
    private static var OK_201: Int { return 201 }
    
    internal static func map(_ data: Data, from response: HTTPURLResponse) throws -> String {
        guard response.statusCode == OK_201,
            let keyId = try? String(decoding: data, as: UTF8.self) else {
            throw FlexSessionCreator.Error.invalidData
        }

        return keyId
    }
}
