//
//  AESGCM.swift
//  flex_api_ios_sdk
//
//  Created by Rakesh Ramamurthy on 21/04/21.
//

import Foundation

func aesGcmEncrypt(plaintext: Data, key: Data, iv: Data, tagLen: Int, aad: Data) throws -> (ciphertext: Data, tag: Data) {
    let cipheredRawData: CybsAGCipheredData?
    do {
        cipheredRawData = try CybsAesGcm.encryptPlainData(plaintext, withAdditionalAuthenticatedData: aad, authenticationTagLength: CybsAGAuthenticationTagLength.AuthTagLength128, initializationVector: iv, key: key)
    } catch {
        throw Tools.createErrorObjectFrom(status: 4000, reason: "Encryption error", message: "Failed to encrypt data")
    }
    
    guard let validRawData = cipheredRawData else {
        throw Tools.createErrorObjectFrom(status: 4000, reason: "Encryption error", message: "Failed to encrypt data")
    }
    
    let unsafeCipheredDataPtr = validRawData.cipheredBuffer.assumingMemoryBound(to: [UInt8].self)
    let cipheredData = Data(bytes: unsafeCipheredDataPtr, count: Int(validRawData.cipheredBufferLength))
    let authenticationData = Data(bytes: validRawData.authenticationTag, count: Int(validRawData.authenticationTagLength.rawValue))
    
    return (cipheredData, authenticationData)
}
