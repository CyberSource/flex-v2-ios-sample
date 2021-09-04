//
//  CryptoUtils.swift
//  flex_api_ios_sdk
//
//  Created by Rakesh Ramamurthy on 13/04/21.
//

import Foundation
import Security

typealias RSAPublicKeyComponents = (
    modulus: Data,
    exponent: Data
)

class CryptoUtils {
    static func publicKey(components: RSAPublicKeyComponents) throws -> SecKey {
        let keyData = try Data.representing(rsaPublicKeyComponents: components)

        // RSA key size is the number of bits of the modulus.
        let keySize = (components.modulus.count * 8)

        let attributes: [String: Any] = [
            kSecAttrKeyType as String: kSecAttrKeyTypeRSA,
            kSecAttrKeyClass as String: kSecAttrKeyClassPublic,
            kSecAttrKeySizeInBits as String: keySize,
            kSecAttrIsPermanent as String: false
        ]

        var error: Unmanaged<CFError>?
        guard let keyReference = SecKeyCreateWithData(keyData as CFData, attributes as CFDictionary, &error) else {
            // swiftlint:disable:next force_unwrapping
            throw error!.takeRetainedValue() as Error
        }

//        guard let key = keyReference as? T else {
//            throw JWKError.cannotConvertToSecKeyChildClasses
//        }

        return keyReference
    }
}

extension Data {
    static func representing(rsaPublicKeyComponents components: RSAPublicKeyComponents) throws -> Data {
        var modulusBytes = [UInt8](components.modulus)
        let exponentBytes = [UInt8](components.exponent)

        // Ensure the modulus is prefixed with 0x00.
        if let prefix = modulusBytes.first, prefix != 0x00 {
            modulusBytes.insert(0x00, at: 0)
        }

        let modulusEncoded = modulusBytes.encode(as: .integer)
        let exponentEncoded = exponentBytes.encode(as: .integer)

        let sequenceEncoded = (modulusEncoded + exponentEncoded).encode(as: .sequence)

        return Data(sequenceEncoded)
    }
}

internal enum ASN1Type {
    case sequence
    case integer

    var tag: UInt8 {
        switch self {
        case .sequence:
            return 0x30
        case .integer:
            return 0x02
        }
    }
}

internal extension Array where Element == UInt8 {
    
    private func lengthField(of valueField: [UInt8]) -> [UInt8] {
        var count = valueField.count

        if count < 128 {
            return [ UInt8(count) ]
        }

        // The number of bytes needed to encode count.
        let lengthBytesCount = Int((log2(Double(count)) / 8) + 1)

        // The first byte in the length field encoding the number of remaining bytes.
        let firstLengthFieldByte = UInt8(128 + lengthBytesCount)

        var lengthField: [UInt8] = []
        for _ in 0..<lengthBytesCount {
            // Take the last 8 bits of count.
            let lengthByte = UInt8(count & 0xff)
            // Add them to the length field.
            lengthField.insert(lengthByte, at: 0)
            // Delete the last 8 bits of count.
            count = count >> 8
        }

        // Include the first byte.
        lengthField.insert(firstLengthFieldByte, at: 0)

        return lengthField
    }

    func encode(as type: ASN1Type) -> [UInt8] {
        var tlvTriplet: [UInt8] = []
        tlvTriplet.append(type.tag)
        tlvTriplet.append(contentsOf: lengthField(of: self))
        tlvTriplet.append(contentsOf: self)

        return tlvTriplet
    }

}
