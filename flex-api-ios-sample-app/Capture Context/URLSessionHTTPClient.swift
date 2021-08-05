//
//  URLSessionHTTPClient.swift
//  flex-api-ios-sample-app
//
//  Created by Rakesh Ramamurthy on 17/03/21.
//

import Foundation
import CryptoKit
import CommonCrypto

class URLSessionHTTPClient: NSObject, HTTPClient, URLSessionDelegate {
    private var session: URLSession?
        
    override init() {}
        
    private struct UnexpectedValuesRepresentation: Error {}
    
    func post(from url: URL, payload: Data, headers: [String: String], completion: @escaping (HTTPClientResult) -> Void) {
        self.session = URLSession(configuration: .ephemeral, delegate: self, delegateQueue: nil)

        let request = self.getRequest(from: url, payload: payload, headers: headers)
        session?.dataTask(with: request, completionHandler: { (data, response, error) in
            if let error = error {
                completion(.failure(error))
            } else if let data = data, let response = response as? HTTPURLResponse {
                completion(.success(data, response))
            } else {
                completion(.failure(UnexpectedValuesRepresentation()))
            }
        }).resume()
    }
    
    private func getRequest(from url: URL, payload: Data, headers: [String: String]) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = payload
        
        return request
    }
}
