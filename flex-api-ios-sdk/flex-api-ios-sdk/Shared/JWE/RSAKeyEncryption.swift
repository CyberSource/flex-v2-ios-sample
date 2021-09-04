//
//  RSAKeyEncryption.swift
//  flex_api_ios_sdk
//
//  Created by Rakesh Ramamurthy on 19/04/21.
//

import Foundation

enum RSAKeyEncryption {
    typealias KeyType = RSA.KeyType

    struct EncryptionMode {
        private let keyManagementAlgorithm: KeyManagementAlgorithm
        private let contentEncryptionAlgorithm: ContentEncryptionAlgorithm
        private let recipientPublicKey: KeyType

        init(
            keyManagementAlgorithm: KeyManagementAlgorithm,
            contentEncryptionAlgorithm: ContentEncryptionAlgorithm,
            recipientPublicKey: KeyType
        ) {
            self.keyManagementAlgorithm = keyManagementAlgorithm
            self.contentEncryptionAlgorithm = contentEncryptionAlgorithm
            self.recipientPublicKey = recipientPublicKey
        }
    }

    struct DecryptionMode {
        private let keyManagementAlgorithm: KeyManagementAlgorithm
        private let contentEncryptionAlgorithm: ContentEncryptionAlgorithm
        private let recipientPrivateKey: KeyType

        init(
            keyManagementAlgorithm: KeyManagementAlgorithm,
            contentEncryptionAlgorithm: ContentEncryptionAlgorithm,
            recipientPrivateKey: KeyType
        ) {
            self.keyManagementAlgorithm = keyManagementAlgorithm
            self.contentEncryptionAlgorithm = contentEncryptionAlgorithm
            self.recipientPrivateKey = recipientPrivateKey
        }
    }
}

extension RSAKeyEncryption.EncryptionMode: EncryptionKeyManagementMode {
    func determineContentEncryptionKey() throws -> (contentEncryptionKey: Data, encryptedKey: Data) {
        let contentEncryptionKey = try SecureRandom.generate(count: contentEncryptionAlgorithm.keyLength)
        let encryptedKey = try RSA.encrypt(contentEncryptionKey, with: recipientPublicKey, and: keyManagementAlgorithm)

        return (contentEncryptionKey, encryptedKey)
    }
}
