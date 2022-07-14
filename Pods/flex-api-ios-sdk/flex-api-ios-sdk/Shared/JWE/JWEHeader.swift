//
//  JWEHeader.swift
//  flex_api_ios_sdk
//
//  Created by Rakesh Ramamurthy on 19/04/21.
//

import Foundation

struct JWEHeader: JWECommonHeader {
    var headerData: Data
    var parameters: [String: Any] {
        didSet {
            guard JSONSerialization.isValidJSONObject(parameters) else {
                return
            }
            // Forcing the try is ok here, because it is valid JSON.
            // swiftlint:disable:next force_try
            headerData = try! JSONSerialization.data(withJSONObject: parameters, options: [])
        }
    }

    /// Initializes a JWE header with given parameters and their original `Data` representation.
    /// Note that this (base64-url decoded) `Data` representation has to be exactly as it was
    /// received from the sender.
    ///
    /// - Parameters:
    ///   - parameters: The `Dictionary` representation of the `headerData` parameter.
    ///   - headerData: The (base64-url decoded) `Data` representation of the `parameters` parameter
    ///                 as it was received from the sender.
    /// - Throws: `HeaderParsingError` if the header cannot be created.
    init(parameters: [String: Any], headerData: Data) throws {
        guard JSONSerialization.isValidJSONObject(parameters) else {
            throw HeaderParsingError.headerIsNotValidJSONObject
        }

        guard parameters["alg"] is String else {
            throw HeaderParsingError.requiredHeaderParameterMissing(parameter: "alg")
        }

        guard parameters["enc"] is String else {
            throw HeaderParsingError.requiredHeaderParameterMissing(parameter: "enc")
        }

        self.headerData = headerData
        self.parameters = parameters
    }

    /// Initializes a `JWEHeader` with the specified algorithm and signing algorithm.
    init(
        keyManagementAlgorithm: KeyManagementAlgorithm,
        contentEncryptionAlgorithm: ContentEncryptionAlgorithm
    ) {
        let parameters = [
            "alg": keyManagementAlgorithm.rawValue,
            "enc": contentEncryptionAlgorithm.rawValue
        ]

        // Forcing the try is ok here, since [String: String] can be converted to JSON.
        // swiftlint:disable:next force_try
        let headerData = try! JSONSerialization.data(withJSONObject: parameters, options: [])

        // Forcing the try is ok here, since "alg" and "enc" are the only required header parameters.
        // swiftlint:disable:next force_try
        try! self.init(parameters: parameters, headerData: headerData)
    }

    /// Initializes a `JWEHeader` with the specified parameters.
    init(parameters: [String: Any]) throws {
        let headerData = try JSONSerialization.data(withJSONObject: parameters, options: [])
        try self.init(parameters: parameters, headerData: headerData)
    }
}

// Header parameters that are specific to a JWE Header.
extension JWEHeader {
    /// The algorithm used to encrypt or determine the value of the Content Encryption Key.
    var keyManagementAlgorithm: KeyManagementAlgorithm? {
        // Forced cast is ok here since we checked both that "alg" exists
        // and holds a `String` value in `init(parameters:)`.
        // swiftlint:disable:next force_cast
        return KeyManagementAlgorithm(rawValue: parameters["alg"] as! String)
    }

    /// The encryption algorithm used to perform authenticated encryption of the plaintext
    /// to produce the ciphertext and the Authentication Tag.
    var contentEncryptionAlgorithm: ContentEncryptionAlgorithm? {
        // Forced cast is ok here since we checked both that "enc" exists
        // and holds a `String` value in `init(parameters:)`.
        // swiftlint:disable:next force_cast
        return ContentEncryptionAlgorithm(rawValue: parameters["enc"] as! String)
    }
}

extension JWEHeader: CommonHeaderParameterSpace {
    /// The JSON Web key corresponding to the key used to encrypt the JWE, as a String.
    var jwk: String? {
        get {
            return parameters["jwk"] as? String
        }
        set {
            parameters["jwk"] = newValue
        }
    }

    /// The Key ID indicates the key which was used to encrypt the JWE.
    var kid: String? {
        get {
            return parameters["kid"] as? String
        }
        set {
            parameters["kid"] = newValue
        }
    }
}
