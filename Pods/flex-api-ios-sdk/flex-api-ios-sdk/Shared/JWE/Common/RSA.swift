//
//  RSA.swift
//  flex_api_ios_sdk
//
//  Created by Rakesh Ramamurthy on 19/04/21.
//

import Foundation
import Security

internal enum RSAError: Error {
    case algorithmNotSupported
    case signingFailed(description: String)
    case verifyingFailed(description: String)
    case plainTextLengthNotSatisfied
    case cipherTextLenghtNotSatisfied
    case encryptingFailed(description: String)
}

internal extension KeyManagementAlgorithm {
    /// Mapping of `AsymmetricKeyAlgorithm` to Security Framework's `SecKeyAlgorithm`.
    var secKeyAlgorithm: SecKeyAlgorithm? {
        switch self {
        case .RSA1_5:
            return .rsaEncryptionPKCS1
        case .RSAOAEP:
            return .rsaEncryptionOAEPSHA1
        case .RSAOAEP256:
            return .rsaEncryptionOAEPSHA256
        }
    }

    func maxMessageLength(for publicKey: SecKey) -> Int? {
        let k = SecKeyGetBlockSize(publicKey)
        switch self {
        case .RSA1_5:
            return (k - 11)
        case .RSAOAEP:
            // The maximum plaintext length is based on
            // the hash length of SHA-1 (https://tools.ietf.org/html/rfc3174#section-1).
            let hLen = 160 / 8
            return k - 2 * hLen - 2
        case .RSAOAEP256:
            // The maximum plaintext length is based on
            // the hash length of SHA-256.
            let hLen = 256 / 8
            return (k - 2 * hLen - 2)
        }
    }
}

fileprivate extension KeyManagementAlgorithm {
    /// Checks if the plain text length does not exceed the maximum
    /// for the chosen algorithm and the corresponding public key.
    /// This length checking is just for usability reasons.
    /// Proper length checking is done in the implementation of iOS'
    /// `SecKeyCreateEncryptedData` and `SecKeyCreateDecryptedData`.
    func isPlainTextLengthSatisfied(_ plainText: Data, for publicKey: SecKey) -> Bool? {
        let mLen = plainText.count

        switch self {
        case .RSA1_5, .RSAOAEP, .RSAOAEP256:
            guard let maxMessageLength = maxMessageLength(for: publicKey) else { return nil }
            return mLen <= maxMessageLength
        }
    }
}

internal struct RSA {
    typealias KeyType = SecKey

    /// Encrypts a plain text using a given `RSA` algorithm and the corresponding public key.
    ///
    /// - Parameters:
    ///   - plaintext: The plain text to encrypt.
    ///   - publicKey: The public key.
    ///   - algorithm: The algorithm used to encrypt the plain text.
    /// - Returns: The cipher text (encrypted plain text).
    /// - Throws: `EncryptionError` if any errors occur while encrypting the plain text.
    static func encrypt(_ plaintext: Data, with publicKey: KeyType, and algorithm: KeyManagementAlgorithm) throws -> Data {
        // Check if `AsymmetricKeyAlgorithm` supports a `SecKeyAlgorithm` and
        // if the algorithm is supported to encrypt with a given public key.
        guard
            let secKeyAlgorithm = algorithm.secKeyAlgorithm,
            SecKeyIsAlgorithmSupported(publicKey, .encrypt, secKeyAlgorithm)
        else {
            throw RSAError.algorithmNotSupported
        }

        // Check if the plain text length does not exceed the maximum.
        // e.g. for RSA1_5 the plaintext must be 11 bytes smaller than the public key's modulus.
        guard algorithm.isPlainTextLengthSatisfied(plaintext, for: publicKey) == true else {
            throw RSAError.plainTextLengthNotSatisfied
        }

        // Encrypt the plain text with a given `SecKeyAlgorithm` and a public key.
        var encryptionError: Unmanaged<CFError>?
        guard
            let cipherText = SecKeyCreateEncryptedData(publicKey, secKeyAlgorithm, plaintext as CFData, &encryptionError)
        else {
            throw RSAError.encryptingFailed(
                description: encryptionError?.takeRetainedValue().localizedDescription ?? "No description available."
            )
        }

        return cipherText as Data
    }
}
