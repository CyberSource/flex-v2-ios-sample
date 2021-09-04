//
//  FlexServiceTests.swift
//  flex-api-ios-sdkTests
//
//  Created by Rakesh Ramamurthy on 09/04/21.
//

import XCTest
@testable import flex_api_ios_sdk

class FlexServiceTests: XCTestCase {
        
    func test_createTransientToken_delieversErrorOnEmptyCaptureContext() {
        let captureContext = ""
        let (sut, _, _) = makeSUT()
        
        var capturedError = [FlexErrorResponse]()
        sut.createTransientToken(from: captureContext, data: anyCardData()) { (result) in
            switch result {
            case .success: break
            case let .failure(error):
                capturedError.append(error)
            }
        }
        
        let expected = FlexInternalErrors.emptyCaptureContext.errorResponse
        XCTAssertEqual(capturedError, [expected])
    }
    
    func test_createTransientToken_delieversErrorOnEmptyData() {
        let emptyData: [String: Any] = [:]
        let (sut, _, _) = makeSUT()
                
        var capturedError = [FlexErrorResponse]()
        sut.createTransientToken(from: anyCaptureCaontext(), data: emptyData) { (result) in
            switch result {
            case .success: break
            case let .failure(error):
                capturedError.append(error)
            }
        }
        
        XCTAssertEqual(capturedError, [FlexInternalErrors.emptyCardData.errorResponse])
    }
    
//    func test_createTransientToken_deliversErrorOnClientConnectivityError() {
//        let (sut, _, httpClient) = makeSUT()
//
//        expect(sut, toCompleteWith: failure(.connectivity), when: {
//            let clientError = NSError(domain: "test", code: 0)
//            httpClient.complete(with: clientError)
//        })
//    }
    
//    func test_createToken_completesWithMissingKIDError() {
//        let (sut, cc, httpClient) = makeSUT()
//
//        sut.createToken(data: anyCardData()) { _ in }
//    }
    
    //MARK - Helpers
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut:FlexService, cc:CaptureContextSpy, httpClient: URLSessionHTTPClientSpy) {
        let captureContext = CaptureContextSpy()
        let httpClient = URLSessionHTTPClientSpy()
        let sut = FlexService(captureContext: captureContext, tokenGenerator: httpClient)
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(captureContext, file: file, line: line)
        trackForMemoryLeaks(httpClient, file: file, line: line)

        return (sut, captureContext, httpClient)
    }
    
    private func expect(_ sut: FlexService, toCompleteWith expectedResult: Result<TransientToken, FlexErrorResponse>, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Wait for create token completion")

        try! sut.createToken(data: anyCardData()) { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(receivedToken), .success(expectedToken)):
                XCTAssertEqual(receivedToken, expectedToken, file: file, line: line)
            case let (.failure(receivedError), .failure(expectedError)):
                XCTAssertEqual(receivedError, expectedError, file: file, line: line)
                
            default:
                XCTFail("Expected result \(expectedResult) got \(receivedResult) instead", file: file, line: line)
            }
            
            exp.fulfill()
        }
        
        action()
        
        waitForExpectations(timeout: 0.1)
    }
    
    private func anyCaptureCaontext() -> String {
        return "eyJraWQiOiI.eyJpc.CM3ht"
    }
    
    private func anyCardData() -> [String: Any] {
        return ["CardNumber": "1234567891234567"]
    }
    
    private func failure(_ error: FlexErrorResponse) -> Result<TransientToken, FlexErrorResponse> {
        return .failure(error)
    }

    private class CaptureContextSpy: CaptureContext {
        
        func getPublicKey() -> SecKey? {
            let modulus = "Test"
            let exponent = "Test"
                    
            var nStr = modulus
            let eStr = exponent
              
            //Padding required
            nStr = nStr.replacingOccurrences(of: "-", with: "+").replacingOccurrences(of: "_", with: "/")
              if nStr.count % 4 == 2 {
               nStr.append("==")
              }
              if nStr.count % 4 == 3 {
               nStr.append("=")
              }
              let nBytes = Data(base64Encoded: nStr)
              /*Same with e*/
              let eBytes = Data(base64Encoded: eStr)
              
            //Now this bytes we have to append such that [48, 130, 1, 10, 2, 130, 1, 1, 0, /* nBytes */, 0x02 , 0x03 ,/* eBytes */ ]
            var padding1 = Data([0x030,0x82,0x01,0x0a,0x02,0x82,0x01,0x01])
            let padding2 = Data([0x02,0x03])
            if nBytes?[0] != 0 {
                padding1.append([0x00], count: 1)
            }
            var keyData = Data(padding1)
            keyData.append(nBytes!)
            keyData.append(padding2)
            keyData.append(eBytes!)
            let attributes: [String: Any] = [
                        kSecAttrKeyType as String: kSecAttrKeyTypeRSA,
                        kSecAttrKeyClass as String: kSecAttrKeyClassPublic,
                        kSecAttrKeySizeInBits as String: 2048,
                        kSecAttrIsPermanent as String: false
                    ]
                    var error: Unmanaged<CFError>?
            let keyReference = SecKeyCreateWithData(keyData as CFData, attributes as CFDictionary, &error)!
            
            return keyReference
        }
        
        func jwe(kid: String, data: [String : Any]) throws -> String? {
            return "jwe string"
        }

        var createTokenCallCount = 0

        func parseData(fromString: String) {
            createTokenCallCount += 1
        }
                        
        func getFlexOrigin() -> String? {
            return "flex origin"
        }
        
        func getTokensPath() -> String? {
            return "tokens path"
        }
        
        func getJsonWebKey() -> JwkClaim? {
            return JwkClaim(kty: "key", e: "e", use: "use", n: "n", kid: "kid")
        }
    }
    
    private class URLSessionHTTPClientSpy: FlexTokensGenerator {
        
        private var messages = [((FlexTokensGenerator.Result) -> Void)]()
        
        func generateTransientToken(url: URL, payload: Data, completion: @escaping (Result<HttpResponse, Error>) -> Void) {
            messages.append((completion))
        }

        func complete(with error: Error, at index: Int = 0) {
            messages[index](.failure(error))
        }
        
        func complete(withStatusCode code: Int, tokenData: String?, headers: [AnyHashable: Any]?, at index: Int = 0) {
            
            let response = HttpResponse(status: code, body: tokenData, headers: headers)
            
            messages[index](.success(response))
        }
    }
}
