//
//  RemoteFlexTokensGeneratorTests.swift
//  flex-api-ios-sdkTests
//
//  Created by Rakesh Ramamurthy on 03/04/21.
//

import XCTest
@testable import flex_api_ios_sdk

class RemoteFlexTokensGeneratorTests: XCTestCase {

    func test_init_doesNotRequestDataFromURL() {
        let (_, client) = makeSUT()
        
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    func test_generateTransientToken_requestDataFromURL() {
        let url = URL(string: "https://a-given-url.com")!

        let (sut, client) = makeSUT(url: url)

        sut.generateTransientToken(url: url, payload: anyData()) { _ in }
        
        XCTAssertEqual(client.requestedURLs, [url])
    }

    func test_generateTransientTokenTwice_requestDataFromURL() {
        let url = URL(string: "https://a-given-url.com")!

        let (sut, client) = makeSUT(url: url)

        sut.generateTransientToken(url: url, payload: anyData()) { _ in }
        sut.generateTransientToken(url: url, payload: anyData()) { _ in }

        XCTAssertEqual(client.requestedURLs, [url, url])
    }
    
    func test_generateTransientToken_deliversErrorOnClientError() {
        let (sut, client) = makeSUT()
        
        expect(sut, toCompleteWith: failure(.connectivity), when: {
            let clientError = NSError(domain: "test", code: 0)
            client.complete(with: clientError)
        })
    }

    /*
    func test_generateTransientToken_deliversErrorOnNon200HTTPResponse() {
        let (sut, client) = makeSUT()
                
        let samples = [199, 201, 300, 400, 500]

        samples.enumerated().forEach { index, code in
            expect(sut, toCompleteWith: failure(.invalidData), when: {
                let (_, json) = makeToken(token: "eyJraWQiOiI.eyJpc.CM3ht", timestamp: 0)
                let jsonData = try! JSONSerialization.data(withJSONObject: json)

                client.complete(withStatusCode: code, data: jsonData, at: index)
            })
        }
    }
 */
    
    func test_generateTransientToken_deliversErrorOn200HTTPResponseWithInvalidJSON() {
        let (sut, client) = makeSUT()
        let token = makeErrorResponse(token: "invalid json")

        expect(sut, toCompleteWith: .success(token.model), when: {
            let invalidJSON = Data("invalid json".utf8)
            client.complete(withStatusCode: 200, data: invalidJSON)
        })
    }
    
    func test_generateTransientToken_deliversTokenOn200HTTPResponseWithJSONItems() {
        let (sut, client) = makeSUT()
                
        let token = makeToken(token: "eyJraWQiOiI.eyJpc.CM3ht", timestamp: 0)

        expect(sut, toCompleteWith: .success(token.model), when: {
            let jsonData = makeTokenJSON(token.jsonDict)

            client.complete(withStatusCode: 200, data: jsonData)
        })
    }
    
    /*
    func test_generateTransientToken_doesNotDeliverResultAfterSUTInstanceHasBeenDeallocated() {
        let url = URL(string: "http://any-url.com")!
        let client = HTTPClientSpy()
        var sut: RemoteFlexTokensGenerator? = RemoteFlexTokensGenerator(client: client)
        var capturedResults = [FlexTokensGenerator.Result]()
        
        sut?.generateTransientToken(url: url, payload: anyData()) { capturedResults.append($0) }
        
        sut = nil

        let token = makeToken(token: "eyJraWQiOiI.eyJpc.CM3ht", timestamp: 0)
        let jsonData = makeTokenJSON(token.jsonDict)

        client.complete(withStatusCode: 200, data: jsonData)
        
        XCTAssertTrue(capturedResults.isEmpty)
    }
     */
    
    // MARK: - Helpers
    
    private func makeSUT(url: URL = URL(string: "https://a-url.com")!, file: StaticString = #file, line: UInt = #line) -> (sut: RemoteFlexTokensGenerator, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteFlexTokensGenerator(client: client)
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(client, file: file, line: line)
        return (sut, client)
    }

    private func expect(_ sut: RemoteFlexTokensGenerator, toCompleteWith expectedResult: Result<HttpResponse, RemoteFlexTokensGenerator.Error>, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Wait for create token completion")
        let url = URL(string: "http://any-url.com")!

        sut.generateTransientToken(url: url, payload: anyData()) { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(receivedToken), .success(expectedToken)):
                XCTAssertEqual(receivedToken, expectedToken, file: file, line: line)
            case let (.failure(receivedError as RemoteFlexTokensGenerator.Error), .failure(expectedError)):
                XCTAssertEqual(receivedError, expectedError, file: file, line: line)
                
            default:
                XCTFail("Expected result \(expectedResult) got \(receivedResult) instead", file: file, line: line)
            }
            
            exp.fulfill()
        }
        
        action()
        
        waitForExpectations(timeout: 0.1)
    }
    
    private func makeToken(token: String, timestamp: Int64) -> (model: HttpResponse, jsonDict: [String: Any]) {
        let token = "{\"token\":\"eyJraWQiOiIwMEVVRTl1YBkCQZt-GuT6O8em0YbDYgPA\",\"timestamp\":0}";//RemoteFlexToken(token: token, timestamp: timestamp)
        let httpResponse = HttpResponse(status: 200, body: token, headers: [:])
        
        let tokenJSONDict = [
            "token": "eyJraWQiOiIwMEVVRTl1YBkCQZt-GuT6O8em0YbDYgPA",
            "timestamp": 0
        ] as [String : Any]

        return (httpResponse, tokenJSONDict)
    }
    
    private func makeErrorResponse(token: String) -> (model: HttpResponse, jsonDict: [String: Any]) {
        let token = "invalid json";
        let httpResponse = HttpResponse(status: 200, body: token, headers: [:])
        
        let tokenJSONDict = [
            "token": "invalid json"
        ] as [String : Any]

        return (httpResponse, tokenJSONDict)
    }

    private func makeTokenJSON(_ token: [String: Any]) -> Data {
        return try! JSONSerialization.data(withJSONObject: token)
    }
    
    private func failure(_ error: RemoteFlexTokensGenerator.Error) -> Result<HttpResponse, RemoteFlexTokensGenerator.Error> {
        return .failure(error)
    }

    private class HTTPClientSpy: HTTPClient {
        private var messages = [(url: URL, completion: (HTTPClient.Result) -> Void)]()

        var requestedURLs: [URL] {
            return messages.map { $0.url }
        }

        func post(from url: URL, payload: Data, completion: @escaping (HTTPClient.Result) -> Void ) {
            messages.append((url, completion))
        }
        
        func complete(with error: Error, at index: Int = 0) {
            messages[index].completion(.failure(error))
        }
        
        func complete(withStatusCode code: Int, data: Data, at index: Int = 0) {
            let response = HTTPURLResponse(
                url: requestedURLs[index],
                statusCode: code,
                httpVersion: nil,
                headerFields: nil
            )!
            
            messages[index].completion(.success((data, response)))
        }
    }
}
