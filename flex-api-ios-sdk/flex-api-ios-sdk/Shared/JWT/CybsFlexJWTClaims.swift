//
//  CybsFlexJWTClaims.swift
//  flex_api_ios_sdk
//
//  Created by Rakesh Ramamurthy on 15/04/21.
//

import Foundation

struct JWTClaims: Claims, Equatable {
    var flx: FlexClaim?
    var ctx: [CTXClaim]?
    var iss: String?
    var exp: Int64?
    var iat: Int64?
    var jti: String?
    init(flx: FlexClaim? = nil) {
        self.flx = flx
    }

    static func == (lhs: JWTClaims, rhs: JWTClaims) -> Bool {
        return lhs.flx == rhs.flx &&
        lhs.ctx == rhs.ctx &&
        lhs.iss == rhs.iss &&
        lhs.exp == rhs.exp &&
        lhs.iat == rhs.iat &&
        lhs.jti == rhs.jti
    }
}

struct FlexClaim: Claims, Equatable {
    var path: String?
    var data: String?
    var origin: String?
    var jwk: JwkClaim?

    static func == (lhs: FlexClaim, rhs: FlexClaim) -> Bool {
        return lhs.path == rhs.path &&
        lhs.data == rhs.data &&
        lhs.origin == rhs.origin &&
        lhs.jwk == rhs.jwk
    }
}

struct CTXClaim: Claims, Equatable {
    var data: DataClaim?
    var type: String?

    static func == (lhs: CTXClaim, rhs: CTXClaim) -> Bool {
        return lhs.data == rhs.data &&
        lhs.type == rhs.type
    }
}

struct DataClaim: Claims, Equatable {
    var requiredFields: [String]?
    var optionalFields: [String]?

    static func == (lhs: DataClaim, rhs: DataClaim) -> Bool {
        return lhs.requiredFields == rhs.requiredFields &&
        lhs.optionalFields == rhs.optionalFields
    }
}

struct JwkClaim: Claims, Equatable {
    var kty: String?
    var e: String?
    var use: String?
    var n: String?
    var kid: String?

    static func == (lhs: JwkClaim, rhs: JwkClaim) -> Bool {
        return lhs.kty == rhs.kty &&
        lhs.e == rhs.e &&
        lhs.use == rhs.use &&
        lhs.n == rhs.n &&
        lhs.kid == rhs.kid
    }
}
