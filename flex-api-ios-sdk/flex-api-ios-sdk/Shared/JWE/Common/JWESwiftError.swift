//
//  JWESwiftError.swift
//  flex_api_ios_sdk
//
//  Created by Rakesh Ramamurthy on 19/04/21.
//

import Foundation

enum JWESwiftError: Error {
    case signingFailed(description: String)
    case verifyingFailed(description: String)
    case signatureInvalid

    case encryptingFailed(description: String)

    case wrongDataEncoding(data: Data)
    case invalidCompactSerializationComponentCount(count: Int)
    case componentNotValidBase64URL(component: String)
    case componentCouldNotBeInitializedFromData(data: Data)

    // Compression erros
    case compressionFailed
    case decompressionFailed
    case compressionAlgorithmNotSupported
    case rawDataMustBeGreaterThanZero
    case compressedDataMustBeGreaterThanZero

    // Thumprint computation
    case thumbprintSerialization
}
