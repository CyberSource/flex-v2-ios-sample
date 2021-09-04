//
//  JWTVerifier.swift
//  flex_api_ios_sdk
//
//  Created by Rakesh Ramamurthy on 15/04/21.
//

import Foundation

struct JWTVerifier {
    let verifierAlgorithm: VerifierAlgorithm
    
    init(verifierAlgorithm: VerifierAlgorithm) {
        self.verifierAlgorithm = verifierAlgorithm
    }
    
    func verify(jwt: String) -> Bool {
        return verifierAlgorithm.verify(jwt: jwt)
    }
             
    /// Initialize a JWTVerifier using the RSA 256 bits algorithm and the provided publicKey.
    /// - Parameter publicKey: The UTF8 encoded PEM public key, with a "BEGIN PUBLIC KEY" header.
    public static func rs256(publicKey: SecKey) -> JWTVerifier {
        return JWTVerifier(verifierAlgorithm: RSAAlgorithm(key: publicKey, keyType: .publicKey))
    }

    /// Initialize a JWTVerifier that will always return true when verifying the JWT. This is equivelent to using the "none" alg header.
    static let none = JWTVerifier(verifierAlgorithm: NoneAlgorithm())
}
