//
//  AESGCMEncryption.swift
//  flex_api_ios_sdk
//
//  Created by Rakesh Ramamurthy on 21/04/21.
//

import Foundation

struct AESGCMEncryption {
    private let contentEncryptionAlgorithm: ContentEncryptionAlgorithm
    private let contentEncryptionKey: Data

    init(contentEncryptionAlgorithm: ContentEncryptionAlgorithm, contentEncryptionKey: Data) {
        self.contentEncryptionAlgorithm = contentEncryptionAlgorithm
        self.contentEncryptionKey = contentEncryptionKey
    }

    func encrypt(_ plaintext: Data, additionalAuthenticatedData: Data) throws -> ContentEncryptionContext {
        let iv = try SecureRandom.generate(count: contentEncryptionAlgorithm.initializationVectorLength)

        let keys = try contentEncryptionAlgorithm.retrieveKeys(from: contentEncryptionKey)
        let encryptionKey = keys.encryptionKey
        
        let encrypted = try AESEncryption.encrypt(plaintext, with: encryptionKey, using: contentEncryptionAlgorithm, additionalAuthenticatedData: additionalAuthenticatedData, and: iv)

        // Put together the input data for the HMAC. It consists of A || IV || E || AL.
        var concatData = additionalAuthenticatedData
        concatData.append(iv)
        concatData.append(encrypted.ciphertext)
        concatData.append(additionalAuthenticatedData.getByteLengthAsOctetHexData())

        let authenticationTag = encrypted.tag

        return ContentEncryptionContext(
            ciphertext: encrypted.ciphertext,
            authenticationTag: authenticationTag,
            initializationVector: iv
        )
    }
}

extension AESGCMEncryption: ContentEncrypter {
    func encrypt(header: JWEHeader, payload: Payload) throws -> ContentEncryptionContext {
        let plaintext = payload.data()
        let additionalAuthenticatedData = header.data().base64URLEncodedData()

        return try encrypt(plaintext, additionalAuthenticatedData: additionalAuthenticatedData)
    }
}

