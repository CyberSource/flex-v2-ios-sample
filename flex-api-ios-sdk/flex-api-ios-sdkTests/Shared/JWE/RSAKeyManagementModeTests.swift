//
//  RSAKeyManagementModeTests.swift
//  flex-api-ios-sdkTests
//
//  Created by Rakesh Ramamurthy on 12/05/21.
//

import XCTest
@testable import flex_api_ios_sdk

class RSAKeyManagementModeTests: RSACryptoTestCase {
    let keyManagementModeAlgorithms: [KeyManagementAlgorithm] = [.RSA1_5, .RSAOAEP, .RSAOAEP256]

    func testGeneratesRandomContentEncryptionKeyOnEachCall() throws {
        for algorithm in keyManagementModeAlgorithms {
            let keyEncryption = RSAKeyEncryption.EncryptionMode(
                keyManagementAlgorithm: algorithm,
                contentEncryptionAlgorithm: .A256GCM,
                recipientPublicKey: publicKeyAlice2048!
            )

            let (cek1, _) = try keyEncryption.determineContentEncryptionKey()
            let (cek2, _) = try keyEncryption.determineContentEncryptionKey()

            XCTAssertNotEqual(cek1, cek2)
        }
    }

    func testEncryptsContentEncryptionKey() throws {
        for algorithm in keyManagementModeAlgorithms {
            let keyEncryption = RSAKeyEncryption.EncryptionMode(
                keyManagementAlgorithm: algorithm,
                contentEncryptionAlgorithm: .A256GCM,
                recipientPublicKey: publicKeyAlice2048!
            )

            let (cek, encryptedKey) = try keyEncryption.determineContentEncryptionKey()

            XCTAssertNotEqual(cek, encryptedKey)

            var decryptionError: Unmanaged<CFError>?
            let decryptedKey = SecKeyCreateDecryptedData(
                privateKeyAlice2048!,
                algorithm.secKeyAlgorithm!,
                encryptedKey as CFData,
                &decryptionError
            )

            XCTAssertNil(decryptionError)
            XCTAssertNotNil(decryptedKey)

            XCTAssertEqual(cek, decryptedKey! as Data)
        }
    }

    func testEncryptsContentEncryptionKeyOnlyForProvidedKey() throws {
        for algorithm in keyManagementModeAlgorithms {
            let keyEncryption = RSAKeyEncryption.EncryptionMode(
                keyManagementAlgorithm: algorithm,
                contentEncryptionAlgorithm: .A256GCM,
                recipientPublicKey: publicKeyAlice2048!
            )

            let (cek, encryptedKey) = try keyEncryption.determineContentEncryptionKey()

            XCTAssertNotEqual(cek, encryptedKey)

            var decryptionError: Unmanaged<CFError>?
            let decryptedKey = SecKeyCreateDecryptedData(
                privateKeyBob2048!,
                algorithm.secKeyAlgorithm!,
                encryptedKey as CFData,
                &decryptionError
            )

            XCTAssertNotNil(decryptionError)
            XCTAssertNil(decryptedKey)
        }
    }

    func testGeneratesContentEncryptionKeyOfCorrectLength() throws {
        let contentEncryptionAlgorithms: [ContentEncryptionAlgorithm] = [.A256GCM]

        for alg in keyManagementModeAlgorithms {
            for enc in contentEncryptionAlgorithms {
                let keyEncryption = RSAKeyEncryption.EncryptionMode(
                    keyManagementAlgorithm: alg,
                    contentEncryptionAlgorithm: enc,
                    recipientPublicKey: publicKeyAlice2048!
                )

                let (cek, _) = try keyEncryption.determineContentEncryptionKey()

                XCTAssertEqual(cek.count, enc.keyLength)
            }
        }
    }
}
