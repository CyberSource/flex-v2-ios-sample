//
//  FlexSessionCreator.swift
//  flex-api-ios-sample-app
//
//  Created by Rakesh Ramamurthy on 17/03/21.
//

import Foundation

final class FlexSessionCreator: FlexCaptureContext {
    private let url: URL
    private let client: HTTPClient
    private let payload: Data
    private let headers: [String: String]
    
    enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    typealias Result = FlexCaptureContextResult
    
    init(url: URL, client: HTTPClient, payload: Data, headers: [String: String]) {
        self.url = url
        self.client = client
        self.payload = payload
        self.headers = headers
    }
    
    func createCaptureContext(completion: @escaping (Result) -> Void) {
        client.post(from: url, payload: payload, headers: headers) { [weak self] result in
            //guard self != nil else { return }
            
            switch result {
            case let .success(data, response):
                completion(FlexSessionCreator.map(data, from: response))
                
            case .failure:
                completion(.failure(Error.connectivity))
            }
        }
    }
    
    private static func map(_ data: Data, from response: HTTPURLResponse) -> Result {
        do {
            let remoteData = try SessionDataMapper.map(data, from: response)
            return .success(SessionData(keyId: remoteData))
        } catch {
            return .failure(error)
        }
    }
}
