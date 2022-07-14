//
//  CaptureContext.swift
//  flex_api_ios_sdk
//
//  Created by Rakesh Ramamurthy on 09/04/21.
//

import Foundation

protocol CaptureContext {
    func getPublicKey() throws -> SecKey?
    func getFlexOrigin() -> String?
    func getTokensPath() -> String?
    func getJsonWebKey() -> JwkClaim?
    func jwe(kid: String, data: [String: Any]) throws -> String?
}
