//
//  JWTTests.swift
//  flex-api-ios-sdkTests
//
//  Created by Rakesh Ramamurthy on 28/04/21.
//

import XCTest
import Foundation

@testable import flex_api_ios_sdk

let rsaPublicKey = read(fileName: "rsa_public_key")
let rsaJWTDecoder = JWTDecoder(jwtVerifier: .none)
let rsaEncodedTestClaimJWT = "eyJraWQiOiJqNCIsImFsZyI6IlJTMjU2In0.eyJmbHgiOnsicGF0aCI6Ii9mbGV4L3YyL3Rva2VucyIsImRhdGEiOiJ5RTgvN2x2eWROdndFUEdOazc4S2hoQUFFTEYxM3NZV25HUnNWcHFNT1dIMHUxbC93OUl2ZmgvOEJxR3Z0OERmVEY1RURWN1F4dVRKeVhBcHVLVW9IRDdUVTFXM3dNV2Fva1JSb3B6ZEdjNXdOalFcdTAwM2QiLCJvcmlnaW4iOiJodHRwczovL3N0YWdlZmxleC5jeWJlcnNvdXJjZS5jb20iLCJqd2siOnsia3R5IjoiUlNBIiwiZSI6IkFRQUIiLCJ1c2UiOiJlbmMiLCJuIjoieWMwWlhKYlZ1SFdaV0loSXBTMGQ0VXhFQXFLSm9saTRnX2tKRjQxNkthWUVBVjVCWFI2bG8wal9tdWxERzFfYkIyTkcyNGt0WXU5TDJHUHpPZ2owTjNIUVQ1dTdpcEhSRG42bEFkYWUzNnRSaEQ0UUR5OGRoUTM3R0tjWm9jcEtDdXJncEpZSkU5NFVKZmtUWUx2OWlEV3dFTVJ6dU5KbUtxcnp4UTlpdVROUXM5WDFQR2h5UmQ1Sl9PSFdaRzBRMjFia2UtVlhQZDJhNjV6b3haR3BjY1UwSVpLMjg1LTFMM2xoNVNOVGFzc3pZZDQyYXNVbnh4NjhmcWV0WXZHRGZFZUxaeV9WX1lUX21fakJPR05ZbjNsc3hZX0dSb0xKamtZdkR4REdaeGNLRGNvOXk2SDRjb2M1bGZOemZoOElFQklNajAwUC1NeUg4OG41d1VvM2F3Iiwia2lkIjoiMDBuTWZwYlA5NjdKODVBTFpEWFNPNm1kc1ljRDNab0cifX0sImN0eCI6W3siZGF0YSI6eyJyZXF1aXJlZEZpZWxkcyI6WyJwYXltZW50SW5mb3JtYXRpb24uY2FyZC5leHBpcmF0aW9uWWVhciIsInBheW1lbnRJbmZvcm1hdGlvbi5jYXJkLm51bWJlciIsInBheW1lbnRJbmZvcm1hdGlvbi5jYXJkLmV4cGlyYXRpb25Nb250aCIsInBheW1lbnRJbmZvcm1hdGlvbi5jYXJkLnNlY3VyaXR5Q29kZSJdLCJvcHRpb25hbEZpZWxkcyI6WyJwYXltZW50SW5mb3JtYXRpb24uY2FyZC50eXBlIl19LCJ0eXBlIjoiYXBpLTAuMS4wIn1dLCJpc3MiOiJGbGV4IEFQSSIsImV4cCI6MTYxODIwNjM3OSwiaWF0IjoxNjE4MjA1NDc5LCJqdGkiOiJhMWRPblZ3ZEZKUUNJOGU0In0.LYxBbmW6ka30dLVo4XiaI9WgjbcvqTBoTEcUuDz1vASF8x8LBSpR1uRzvd5rOxD2Nd9ASFW-4oySvOeq6vK8xKnAzieLhmvoMunyLSdOAVDXtArU9oO3fbUZMQKCHQp87XzC4oYSu6WdhG8ZpjCDam0wh97dBU-znhxUoaz7xaCSC-cPrBQn0BzIgkhK8WsPe1gWQ6O3UZPCuJzsKXxWtfxhEED32gYZGUtQ1ii2H2mYkMoLdDwunkNryHbMY4ETLTPMOlnKoFwuLidzGBHaU4BbxmbbmE88kyD_P-JHFt9nGthhcqzVgAnMfvDMyjYnpCpZ_W8RwQ9Pb1lwBVVG7A"

let jwtVerifiers: [String: JWTVerifier] = ["0": .none, "1": .none]
let rsaJWTKidDecoder = JWTDecoder(keyIDToVerifier: { kid in return jwtVerifiers[kid]})

@available(macOS 10.12, iOS 10.0, *)
class TestJWT: XCTestCase {
    
    static var allTests: [(String, (TestJWT) -> () throws -> Void)] {
        return [
            ("testJWTDecoder", testJWTDecoder),
            //("testJWT", testJWT),
        ]
    }

    // This test uses the rsaJWTDecoder to decode the rsaEncodedTestClaimJWT as a JWT<TestClaims>.
    // The test checks that the decoded JWT is the same as the JWT that was originally encoded.
    func testJWTDecoder() {
        let jwk: JwkClaim = JwkClaim(kty: "RSA",
                           e: "AQAB",
                           use: "enc",
                           n: "yc0ZXJbVuHWZWIhIpS0d4UxEAqKJoli4g_kJF416KaYEAV5BXR6lo0j_mulDG1_bB2NG24ktYu9L2GPzOgj0N3HQT5u7ipHRDn6lAdae36tRhD4QDy8dhQ37GKcZocpKCurgpJYJE94UJfkTYLv9iDWwEMRzuNJmKqrzxQ9iuTNQs9X1PGhyRd5J_OHWZG0Q21bke-VXPd2a65zoxZGpccU0IZK285-1L3lh5SNTasszYd42asUnxx68fqetYvGDfEeLZy_V_YT_m_jBOGNYn3lsxY_GRoLJjkYvDxDGZxcKDco9y6H4coc5lfNzfh8IEBIMj00P-MyH88n5wUo3aw",
                           kid: "00nMfpbP967J85ALZDXSO6mdsYcD3ZoG")
        
        let flx = FlexClaim(path: "/flex/v2/tokens",
                            data: "yE8/7lvydNvwEPGNk78KhhAAELF13sYWnGRsVpqMOWH0u1l/w9Ivfh/8BqGvt8DfTF5EDV7QxuTJyXApuKUoHD7TU1W3wMWaokRRopzdGc5wNjQ=",
                            origin: "https://stageflex.cybersource.com",
                            jwk: jwk)
        
        let data = DataClaim(requiredFields: ["paymentInformation.card.expirationYear",
                                              "paymentInformation.card.number",
                                              "paymentInformation.card.expirationMonth",
                                              "paymentInformation.card.securityCode"],
                             optionalFields: ["paymentInformation.card.type"])

        let ctx = [CTXClaim(data: data, type: "api-0.1.0")]
        
        var jwtClaims = JWTClaims()
        jwtClaims.flx = flx
        jwtClaims.ctx = ctx
        jwtClaims.iat = 1618205479
        jwtClaims.jti = "a1dOnVwdFJQCI8e4"
        jwtClaims.exp = 1618206379
        jwtClaims.iss = "Flex API"

        var header = Header(typ: nil, jwk: nil, kid: "j4")
        header.alg = "RS256"
        
        let expectedJwt = JWT(header: header, claims: jwtClaims)
        do {
            let decodedJWT = try rsaJWTDecoder.decode(JWT<JWTClaims>.self, fromString: rsaEncodedTestClaimJWT)
            XCTAssertEqual(decodedJWT.claims.ctx, expectedJwt.claims.ctx)
            XCTAssertEqual(decodedJWT.claims.flx, expectedJwt.claims.flx)

            XCTAssertEqual(decodedJWT.claims.iat, expectedJwt.claims.iat)
            XCTAssertEqual(decodedJWT.claims.exp, expectedJwt.claims.exp)
            XCTAssertEqual(decodedJWT.claims.iss, expectedJwt.claims.iss)
            XCTAssertEqual(decodedJWT.claims.jti, expectedJwt.claims.jti)

            XCTAssertEqual(decodedJWT.header.alg, header.alg)
            XCTAssertEqual(decodedJWT.header.kid, header.kid)
        } catch {
            XCTFail("Failed to encode JTW: \(error)")
        }
    }

    // From jwt.io
//    func testJWT() {
//        let ok = JWT<TestClaims>.verify(rsaEncodedTestClaimJWT, using: .none)
//        XCTAssertTrue(ok, "Verification failed")
//
//        if let decoded = try? JWT<TestClaims>(jwtString: rsaEncodedTestClaimJWT) {
//            XCTAssertEqual(decoded.header.alg, "RS256", "Wrong .alg in decoded")
//            XCTAssertEqual(decoded.header.typ, "JWT", "Wrong .typ in decoded")
//
//            //XCTAssertEqual(decoded.claims.flx, "John Doe", "Wrong .name in decoded")
//            //XCTAssertEqual(decoded.claims.ctx, true, "Wrong .admin in decoded")
//            XCTAssertEqual(decoded.claims.iat, Date(timeIntervalSince1970: 1516239022), "Wrong .iat in decoded")
//
//
//            XCTAssertEqual(decoded.validateClaims(), .success, "Validation failed")
//        }
//        else {
//            XCTFail("Failed to decode")
//        }
//    }
}

func read(fileName: String) -> Data {
    do {
        var pathToTests = #file
        if pathToTests.hasSuffix("JWTSampleTests.swift") {
            pathToTests = pathToTests.replacingOccurrences(of: "JWTSampleTests.swift", with: "")
        }
        let fileData = try Data(contentsOf: URL(fileURLWithPath: "\(pathToTests)\(fileName)"))
        XCTAssertNotNil(fileData, "Failed to read in the \(fileName) file")
        return fileData
    } catch {
        XCTFail("Error in \(fileName).")
        exit(1)
    }
}
