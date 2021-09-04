//
//  JWT.swift
//  flex_api_ios_sdk
//
//  Created by Rakesh Ramamurthy on 15/04/21.
//

import Foundation

struct JWT<T: Claims>: Codable {
    
    /// The JWT header.
    var header: Header
    
    /// The JWT claims
    var claims: T
    
    /// Initialize a `JWT` instance from a `Header` and `Claims`.
    ///
    /// - Parameter header: A JSON Web Token header object.
    /// - Parameter claims: A JSON Web Token claims object.
    /// - Returns: A new instance of `JWT`.
    init(header: Header = Header(), claims: T) {
        self.header = header
        self.claims = claims
    }
    
    /// Initialize a `JWT` instance from a JWT String.
    /// The signature will be verified using the provided JWTVerifier.
    /// The time based standard JWT claims will be verified with `validateClaims()`.
    /// If the string is not a valid JWT, or the verification fails, the initializer returns nil.
    ///
    /// - Parameter jwt: A String with the encoded and signed JWT.
    /// - Parameter verifier: The `JWTVerifier` used to verify the JWT.
    /// - Returns: An instance of `JWT` if the decoding succeeds.
    /// - Throws: `JWTError.invalidJWTString` if the provided String is not in the form mandated by the JWT specification.
    /// - Throws: `JWTError.failedVerification` if the verifier fails to verify the jwtString.
    /// - Throws: A DecodingError if the JSONDecoder throws an error while decoding the JWT.
    init(jwtString: String, verifier: JWTVerifier = .none ) throws {
        let components = jwtString.components(separatedBy: ".")
        guard components.count == 2 || components.count == 3,
            let headerData = JWTDecoder.data(base64urlEncoded: components[0]),
            let claimsData = JWTDecoder.data(base64urlEncoded: components[1])
        else {
            throw JWTError.invalidJWTString
        }
        guard JWT.verify(jwtString, using: verifier) else {
            throw JWTError.failedVerification
        }
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .iso8601
        let header = try jsonDecoder.decode(Header.self, from: headerData)
        let claims = try jsonDecoder.decode(T.self, from: claimsData)
        self.header = header
        self.claims = claims
    }
    
    /// Verify the signature of the encoded JWT using the given algorithm.
    ///
    /// - Parameter jwt: A String with the encoded and signed JWT.
    /// - Parameter using algorithm: The algorithm to verify with.
    /// - Returns: A Bool indicating whether the verification was successful.
    static func verify(_ jwt: String, using jwtVerifier: JWTVerifier) -> Bool {
        return jwtVerifier.verify(jwt: jwt)
    }
        
    func validateClaims(expDate: Int64, iatDate: Int64) -> ValidateClaimsResult {
        let leeway: TimeInterval = 1
        
        let expTimeInterval = TimeInterval(expDate)
        let iatTimeInterval = TimeInterval(iatDate)

        let expirationDate = Date(timeIntervalSince1970: expTimeInterval)

        let issuedAtDate = Date(timeIntervalSince1970: iatTimeInterval)
        
        let currentDate = Date()

        if expirationDate < currentDate {
            return .expired
        }
        
        if issuedAtDate > currentDate + leeway {
            return .issuedAt
        }

        return .success
    }

}
