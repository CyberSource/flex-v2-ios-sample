//
//  AES.swift
//  flex_api_ios_sdk
//
//  Created by Rakesh Ramamurthy on 19/04/21.
//

import Foundation
import CommonCrypto

enum AESEncryption {

    typealias KeyType = Data

    static func encrypt(
        _ plaintext: Data,
        with encryptionKey: KeyType,
        using algorithm: ContentEncryptionAlgorithm,
        additionalAuthenticatedData: Data = Data(),
        and initializationVector: Data
    ) throws -> (ciphertext: Data, tag: Data) {
        let encrypted = try ccAESGCMEncryption(plaintext, keyEncryptionKey: encryptionKey, iv: initializationVector, additionalAuthenticatedData: additionalAuthenticatedData)
        
        return (encrypted.ciphertext, encrypted.tag)
    }
}

extension AESEncryption {
    private static func ccAESGCMEncryption (
        _ plaintext: Data,
        keyEncryptionKey: Data,
        iv: Data,
        additionalAuthenticatedData: Data) throws -> (ciphertext: Data, tag: Data) {
        let (ciphertext, tag) = try aesGcmEncrypt(plaintext: plaintext, key: keyEncryptionKey, iv: iv, tagLen: 128, aad: additionalAuthenticatedData)
        
        return (ciphertext, tag)
    }
}
