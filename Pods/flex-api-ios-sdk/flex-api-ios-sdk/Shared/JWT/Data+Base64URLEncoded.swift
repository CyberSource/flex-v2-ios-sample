//
//  Data+Base64URLEncoded.swift
//  flex_api_ios_sdk
//
//  Created by Rakesh Ramamurthy on 15/04/21.
//

import Foundation

/// Convenience extension for decoding a `Data` from a base64url-encoded `String`.
extension JWTDecoder {
    
    /// Initializes a new `Data` from the base64url-encoded `String` provided. The
    /// base64url encoding is defined in RFC4648 (https://tools.ietf.org/html/rfc4648).
    ///
    /// This is appropriate for reading the header or claims portion of a JWT string.
    static func data(base64urlEncoded: String) -> Data? {
        let paddingLength = 4 - base64urlEncoded.count % 4
        let padding = (paddingLength < 4) ? String(repeating: "=", count: paddingLength) : ""
        let base64EncodedString = base64urlEncoded
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")
            + padding
        return Data(base64Encoded: base64EncodedString)
    }
}
