//
//  SecureRandom.swift
//  flex_api_ios_sdk
//
//  Created by Rakesh Ramamurthy on 19/04/21.
//

import Foundation
import Security

enum SecureRandomError: Error {
    case failed(status: OSStatus)
    case countMustBeGreaterThanZero
}

struct SecureRandom {
    /// Generates secure random data with a given count.
    ///
    /// - Parameter count: The count of the random generated data. Must be greater than 0.
    /// - Returns: The random generated data.
    /// - Throws: `SecureRandomError` if any error occurs during generation of secure random bytes.
    static func generate(count: Int) throws -> Data {
        guard count > 0 else {
            throw SecureRandomError.countMustBeGreaterThanZero
        }

        var generatedRandom = Data(count: count)

        let randomGenerationStatus = generatedRandom.withUnsafeMutableBytes { mutableRandomBytes in
            // Force unwrapping is ok, since the buffer is guaranteed not to be empty.
            // From the docs: If the baseAddress of this buffer is nil, the count is zero.
            // swiftlint:disable:next force_unwrapping
            SecRandomCopyBytes(kSecRandomDefault, count, mutableRandomBytes.baseAddress!)
        }

        guard randomGenerationStatus == errSecSuccess else {
            throw SecureRandomError.failed(status: randomGenerationStatus)
        }

        return generatedRandom
    }
}
