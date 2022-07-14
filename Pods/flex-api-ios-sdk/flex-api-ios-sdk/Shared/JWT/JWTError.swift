//
//  JWTError.swift
//  flex_api_ios_sdk
//
//  Created by Rakesh Ramamurthy on 15/04/21.
//

import Foundation

struct JWTError: Swift.Error, Equatable {

    /// A human readable description of the error.
    let localizedDescription: String
    
    private let internalError: InternalError
    
    private enum InternalError {
        case invalidJWTString, failedVerification, osVersionToLow, invalidData, invalidKeyID
    }
    
    /// Error when an invalid JWT String is provided
    static let invalidJWTString = JWTError(localizedDescription: "Input was not a valid JWT String", internalError: .invalidJWTString)
    
    /// Error when the JWT signiture fails verification.
    static let failedVerification = JWTError(localizedDescription: "JWT verifier failed to verify the JWT String signiture", internalError: .failedVerification)
    
    /// Error when using RSA encryption with an OS version that is too low.
    static let osVersionToLow = JWTError(localizedDescription: "macOS 10.12.0 (Sierra) or higher or iOS 10.0 or higher is required by CryptorRSA", internalError: .osVersionToLow)
    
    /// Error when the provided Data cannot be decoded to a String
    static let invalidUTF8Data = JWTError(localizedDescription: "Could not decode Data from UTF8 to String", internalError: .invalidData)
    
    /// Error when the KeyID field `kid` in the JWT header fails to generate a JWTSigner or JWTVerifier
    static let invalidKeyID = JWTError(localizedDescription: "The JWT KeyID `kid` header failed to generate a JWTSigner/JWTVerifier", internalError: .invalidKeyID)
        
    /// Function to check if JWTErrors are equal. Required for equatable protocol.
    static func == (lhs: JWTError, rhs: JWTError) -> Bool {
        return lhs.internalError == rhs.internalError
    }

    /// Function to enable pattern matching against generic Errors.
    static func ~= (lhs: JWTError, rhs: Error) -> Bool {
        guard let rhs = rhs as? JWTError else {
            return false
        }
        return lhs == rhs
    }
}
