//
//  Header.swift
//  flex_api_ios_sdk
//
//  Created by Rakesh Ramamurthy on 15/04/21.
//

import Foundation

struct Header: Codable {
    
    /// Type Header Parameter
    var typ: String?
    /// Algorithm Header Parameter
    var alg: String?
    /// JSON Web Key Header Parameter
    var jwk: String?
    /// Key ID Header Parameter
    var kid: String?
    
    /// Initialize a `Header` instance.
    ///
    /// - Parameter typ: The Type Header Parameter
    /// - Parameter jwk: The JSON Web Key Header Parameter
    /// - Parameter kid: The Key ID Header Parameter
    /// - Returns: A new instance of `Header`.
    init(
        typ: String? = "JWT",
        jwk: String? = nil,
        kid: String? = nil
    ) {
        self.typ = typ
        self.alg = nil
        self.jwk = jwk
        self.kid = kid
    }
}
