//
//  JWEHeaderTests.swift
//  flex-api-ios-sdkTests
//
//  Created by Rakesh Ramamurthy on 04/05/21.
//

import XCTest
@testable import flex_api_ios_sdk

class JWEHeaderTests: XCTestCase {

    let parameterDictRSAOAEP = ["alg": "RSA-OAEP", "enc": "A256GCM"]
    let parameterDataRSAOAEP = try! JSONSerialization.data(withJSONObject: ["alg": "RSA-OAEP", "enc": "A256GCM"], options: [])

    func testInitRSAOAEPWithParameters() {
        let header = try! JWEHeader(parameters: parameterDictRSAOAEP)

        XCTAssertEqual(header.parameters["enc"] as? String, ContentEncryptionAlgorithm.A256GCM.rawValue)
        XCTAssertEqual(header.parameters["alg"] as? String, KeyManagementAlgorithm.RSAOAEP.rawValue)
        XCTAssertEqual(header.data().count, try! JSONSerialization.data(withJSONObject: parameterDictRSAOAEP, options: []).count)
    }

    func testInitRSAOAEPWithData() {
        let data = try! JSONSerialization.data(withJSONObject: parameterDictRSAOAEP, options: [])
        let header = JWEHeader(data)!

        XCTAssertEqual(header.parameters["enc"] as? String, ContentEncryptionAlgorithm.A256GCM.rawValue)
        XCTAssertEqual(header.parameters["alg"] as? String, KeyManagementAlgorithm.RSAOAEP.rawValue)
        XCTAssertEqual(header.data(), data)
    }

    func testInitWithAlgAndEncRSAOAEP() {
        let header = JWEHeader(keyManagementAlgorithm: .RSAOAEP, contentEncryptionAlgorithm: .A256GCM)

        XCTAssertEqual(header.data().count, try! JSONSerialization.data(withJSONObject: parameterDictRSAOAEP, options: []).count)
        XCTAssertEqual(header.parameters["alg"] as? String, KeyManagementAlgorithm.RSAOAEP.rawValue)
        XCTAssertEqual(header.parameters["enc"] as? String, ContentEncryptionAlgorithm.A256GCM.rawValue)

        XCTAssertNotNil(header.keyManagementAlgorithm)
        XCTAssertNotNil(header.contentEncryptionAlgorithm)
        XCTAssertEqual(header.keyManagementAlgorithm!, .RSAOAEP)
        XCTAssertEqual(header.contentEncryptionAlgorithm!, .A256GCM)
    }

    func testInitWithMissingRequiredEncParameter() {
        do {
            _ = try JWEHeader(parameters: ["alg": "RSA-OAEP"], headerData: try! JSONSerialization.data(withJSONObject: ["alg": "RSA1_5"], options: []))
        } catch HeaderParsingError.requiredHeaderParameterMissing(let parameter) {
            XCTAssertEqual(parameter, "enc")
            return
        } catch {
            XCTFail()
        }

        XCTFail()
    }

    func testInitDirectlyWithMissingRequiredAlgParameter() {
        do {
            _ = try JWEHeader(parameters: ["enc": "something"], headerData: try! JSONSerialization.data(withJSONObject: ["enc": "something"], options: []))
        } catch HeaderParsingError.requiredHeaderParameterMissing(let parameter) {
            XCTAssertEqual(parameter, "alg")
            return
        } catch {
            XCTFail()
        }

        XCTFail()
    }

    func testInitWithMissingRequiredAlgParameter() {
        do {
            _ = try JWEHeader(parameters: ["enc": "something"])
        } catch HeaderParsingError.requiredHeaderParameterMissing(let parameter) {
            XCTAssertEqual(parameter, "alg")
            return
        } catch {
            XCTFail()
        }

        XCTFail()
    }

    func testSetNonRequiredHeaderParametersInJWEHeader() {
        let jwk = "jwk"
        let kid = "kid"

        var header = JWEHeader(keyManagementAlgorithm: .RSAOAEP, contentEncryptionAlgorithm: .A256GCM)
        header.jwk = jwk
        header.kid = kid

        XCTAssertEqual(header.data().count, try! JSONSerialization.data(withJSONObject: header.parameters, options: []).count)

        XCTAssertEqual(header.parameters["jwk"] as? String, jwk)
        XCTAssertEqual(header.jwk, jwk)

        XCTAssertEqual(header.parameters["kid"] as? String, kid)
        XCTAssertEqual(header.kid, kid)
    }
}
