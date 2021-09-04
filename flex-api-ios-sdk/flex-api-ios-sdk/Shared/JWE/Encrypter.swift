//
//  Encrypter.swift
//  flex_api_ios_sdk
//
//  Created by Rakesh Ramamurthy on 19/04/21.
//

import Foundation

struct Encrypter<KeyType> {
    private let keyManagementMode: EncryptionKeyManagementMode
    private let keyManagementAlgorithm: KeyManagementAlgorithm
    private let contentEncryptionAlgorithm: ContentEncryptionAlgorithm

    /// Constructs an encrypter that can be used to encrypt a JWE.
    ///
    /// - Parameters:
    ///   - keyManagementAlgorithm: The algorithm used to encrypt the content encryption key.
    ///   - contentEncryptionAlgorithm: The algorithm used to encrypt the JWE's payload.
    ///   - encryptionKey: The key used to perform the encryption. The function of the key depends on the chosen key
    ///                    management algorithm.
    ///     - For _key encryption_ it is the public key (`SecKey`) of the recipient to which the JWE should be
    ///       encrypted.
    ///     - For _direct encryption_ it is the secret symmetric key (`Data`) shared between the sender and the
    ///       recipient.
    init?(
        keyManagementAlgorithm: KeyManagementAlgorithm,
        contentEncryptionAlgorithm: ContentEncryptionAlgorithm,
        encryptionKey: KeyType
    ) {
        self.keyManagementAlgorithm = keyManagementAlgorithm
        self.contentEncryptionAlgorithm = contentEncryptionAlgorithm

        let mode = keyManagementAlgorithm.makeEncryptionKeyManagementMode(
            contentEncryptionAlgorithm: contentEncryptionAlgorithm,
            encryptionKey: encryptionKey
        )
        guard let keyManagementMode = mode else { return nil }
        self.keyManagementMode = keyManagementMode
    }

    func encrypt(header: JWEHeader, payload: Payload) throws -> EncryptionContext {
        guard let alg = header.keyManagementAlgorithm, alg == keyManagementAlgorithm else {
            throw JWEError.keyManagementAlgorithmMismatch
        }

        guard let enc = header.contentEncryptionAlgorithm, enc == contentEncryptionAlgorithm else {
            throw JWEError.contentEncryptionAlgorithmMismatch
        }

        let (contentEncryptionKey, encryptedKey) = try keyManagementMode.determineContentEncryptionKey()

        let contentEncryptionContext = try contentEncryptionAlgorithm
            .makeContentEncrypter(contentEncryptionKey: contentEncryptionKey)
            .encrypt(header: header, payload: payload)

        return EncryptionContext(
            encryptedKey: encryptedKey,
            ciphertext: contentEncryptionContext.ciphertext,
            authenticationTag: contentEncryptionContext.authenticationTag,
            initializationVector: contentEncryptionContext.initializationVector
        )
    }
}

extension Encrypter {
    struct EncryptionContext {
        let encryptedKey: Data
        let ciphertext: Data
        let authenticationTag: Data
        let initializationVector: Data
    }
}
