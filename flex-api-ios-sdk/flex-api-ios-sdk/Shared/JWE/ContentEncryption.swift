//
//  ContentEncryption.swift
//  flex_api_ios_sdk
//
//  Created by Rakesh Ramamurthy on 19/04/21.
//

import Foundation

struct ContentEncryptionContext {
    let ciphertext: Data
    let authenticationTag: Data
    let initializationVector: Data
}

struct ContentDecryptionContext {
    let ciphertext: Data
    let initializationVector: Data
    let additionalAuthenticatedData: Data
    let authenticationTag: Data
}

protocol ContentEncrypter {
    func encrypt(header: JWEHeader, payload: Payload) throws -> ContentEncryptionContext
}

extension ContentEncryptionAlgorithm {
    func makeContentEncrypter(contentEncryptionKey: Data) -> ContentEncrypter {
        switch self {
        case .A256GCM:
            return AESGCMEncryption(contentEncryptionAlgorithm: self, contentEncryptionKey: contentEncryptionKey)
        }
    }
}
