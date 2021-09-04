//
//  Algorithms.swift
//  flex_api_ios_sdk
//
//  Created by Rakesh Ramamurthy on 19/04/21.
//

import Foundation

/// Cryptographic algorithms for key management.
///
/// See [RFC 7518, Section 4](https://tools.ietf.org/html/rfc7518#section-4).
enum KeyManagementAlgorithm: String, CaseIterable {
    /// Key encryption using RSAES-PKCS1-v1_5
    case RSA1_5 = "RSA1_5"
    /// Key encryption using RSAES OAEP using SHA-1 and MGF1 with SHA-1
    case RSAOAEP = "RSA-OAEP"
    /// Key encryption using RSAES OAEP using SHA-256 and MGF1 with SHA-256
    case RSAOAEP256 = "RSA-OAEP-256"
}

enum ContentEncryptionAlgorithm: String {
    case A256GCM = "A256GCM"    
}

enum CompressionAlgorithm: String {
    case NONE = "NONE"
}
