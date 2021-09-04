//
//  CryptoTestCase.swift
//  flex-api-ios-sdkTests
//
//  Created by Rakesh Ramamurthy on 12/05/21.
//

import XCTest

class CryptoTestCase: XCTestCase {
    let message = "The true sign of intelligence is not knowledge but imagination."

    override func setUp() {
        super.setUp()
        setupKeys()
    }

    override func tearDown() {
        super.tearDown()
    }

    public func setupKeys() {
        XCTFail("Setup keys function is missing")
    }

    static func setupSecKeyPair(type: String, size: Int, data: Data, tag: String) -> (privateKey: SecKey, publicKey: SecKey)? {
        let attributes: [String: Any] = [
            kSecAttrKeyType as String: type,
            kSecAttrKeyClass as String: kSecAttrKeyClassPrivate,
            kSecAttrKeySizeInBits as String: size,
            kSecPrivateKeyAttrs as String: [
                kSecAttrIsPermanent as String: false,
                kSecAttrApplicationTag as String: tag
            ]
        ]

        var error: Unmanaged<CFError>?
        guard let privateKey = SecKeyCreateWithData(data as CFData, attributes as CFDictionary, &error) else {
            print(error!)
            return nil
        }

        let publicKey = SecKeyCopyPublicKey(privateKey)!

        return (privateKey, publicKey)
    }
}

extension String {

    func hexadecimalToData() -> Data? {
        var data = Data(capacity: count / 2)

        let regex = try! NSRegularExpression(pattern: "[0-9a-f]{1,2}", options: .caseInsensitive)
        regex.enumerateMatches(in: self, range: NSRange(location: 0, length: utf16.count)) { match, _, _ in
            let byteString = (self as NSString).substring(with: match!.range)
            var num = UInt8(byteString, radix: 16)!
            data.append(&num, count: 1)
        }

        guard data.count > 0 else { return nil }

        return data
    }

}

extension Data {
    func toHexadecimal() -> String {
        return map { String(format: "%02x", $0) }
            .joined(separator: "")
    }
}
