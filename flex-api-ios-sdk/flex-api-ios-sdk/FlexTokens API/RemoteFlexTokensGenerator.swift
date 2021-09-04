//
//  RemoteFlexTokensGenerator.swift
//  flex_api_ios_sdk
//
//  Created by Rakesh Ramamurthy on 03/04/21.
//

import Foundation

final class RemoteFlexTokensGenerator: FlexTokensGenerator {
    private let client: HTTPClient
    
    enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
            
    init(client: HTTPClient) {
        self.client = client
    }
    
    func generateTransientToken(url: URL, payload: Data, completion: @escaping (FlexTokensGenerator.Result) -> Void) {
        client.post(from: url, payload: payload) { result in
            //guard self != nil else { return }

            switch result {
            case let .success((data, response)):
                if let responseString = String(data: data, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue)) {
                    print(responseString)
                    
                    let response = HttpResponse(status: response.statusCode, body: responseString, headers: response.allHeaderFields)
                    completion(.success(response))
                } else {
                    completion(.failure(Error.invalidData))
                }
            case .failure:
                completion(.failure(Error.connectivity))
            }
        }
    }
}
