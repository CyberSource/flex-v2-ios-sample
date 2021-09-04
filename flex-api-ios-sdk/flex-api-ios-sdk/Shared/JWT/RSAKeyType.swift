//
//  RSAKeyType.swift
//  flex_api_ios_sdk
//
//  Created by Rakesh Ramamurthy on 15/04/21.
//

import Foundation

/// The type of the key used in the RSA algorithm.
enum RSAKeyType {
    /// The key is a certificate containing both the private and the public keys.
    case certificate
    
    /// The key is an RSA public key.
    case publicKey
    
    /// The key is an RSA private key.
    case privateKey
}
