//
//  JWE.swift
//  flex_api_ios_sdk
//
//  Created by Rakesh Ramamurthy on 19/04/21.
//

import Foundation

import Foundation

internal enum JWEError: Error {
    case keyManagementAlgorithmMismatch
    case contentEncryptionAlgorithmMismatch
    case keyLengthNotSatisfied
    case hmacNotAuthenticated
}

struct JWE {
    /// The JWE Header.
    let header: JWEHeader

    /// The encrypted content encryption key (CEK).
    let encryptedKey: Data

    /// The initialization value used when encrypting the plaintext.
    let initializationVector: Data

    /// The ciphertext resulting from authenticated encryption of the plaintext.
    let ciphertext: Data

    /// The output of an authenticated encryption with associated data that ensures the integrity of the ciphertext and the additional associeated data.
    let authenticationTag: Data

    /// The compact serialization of this JWE object as string.
    var compactSerializedString: String {
        return JWESerializer().serialize(compact: self)
    }

    /// The compact serialization of this JWE object as data.
    var compactSerializedData: Data {
        // Force unwrapping is ok here, since `serialize` returns a string generated from data.
        // swiftlint:disable:next force_unwrapping
        return JWESerializer().serialize(compact: self).data(using: .utf8)!
    }

    /// Constructs a JWS object from a given header, payload, and signer.
    ///
    /// - Parameters:
    ///   - header: A fully initialized `JWEHeader`.
    ///   - payload: A fully initialized `Payload`.
    ///   - encrypter: The `Encrypter` used to encrypt the JWE from the header and payload.
    /// - Throws: `JWESwiftError` if any error occurs while encrypting.
    init<KeyType>(header: JWEHeader, payload: Payload, encrypter: Encrypter<KeyType>) throws {
        self.header = header

        var encryptionContext: Encrypter<KeyType>.EncryptionContext
        do {
            encryptionContext = try encrypter.encrypt(header: header, payload: payload)
        } catch JWESwiftError.compressionFailed {
            throw JWESwiftError.compressionFailed
        } catch JWESwiftError.compressionAlgorithmNotSupported {
            throw JWESwiftError.compressionAlgorithmNotSupported
        } catch {
            throw JWESwiftError.encryptingFailed(description: error.localizedDescription)
        }

        self.encryptedKey = encryptionContext.encryptedKey
        self.ciphertext = encryptionContext.ciphertext
        self.initializationVector = encryptionContext.initializationVector
        self.authenticationTag = encryptionContext.authenticationTag
    }

    /// Initializes a JWE by providing all of it's five parts. Only used during deserialization.
    fileprivate init(header: JWEHeader, encryptedKey: Data, initializationVector: Data, ciphertext: Data, authenticationTag: Data) {
        self.header = header
        self.encryptedKey = encryptedKey
        self.initializationVector = initializationVector
        self.ciphertext = ciphertext
        self.authenticationTag = authenticationTag
    }
}

/// Serialize the JWE to a given compact serializer.
extension JWE: CompactSerializable {
    func serialize(to serializer: inout CompactSerializer) {
        serializer.serialize(header)
        serializer.serialize(encryptedKey)
        serializer.serialize(initializationVector)
        serializer.serialize(ciphertext)
        serializer.serialize(authenticationTag)
    }
}
