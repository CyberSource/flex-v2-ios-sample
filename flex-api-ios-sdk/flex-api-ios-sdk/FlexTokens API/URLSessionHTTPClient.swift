//
//  URLSessionHTTPClient.swift
//  flex_api_ios_sdk
//
//  Created by Rakesh Ramamurthy on 07/04/21.
//

import Foundation

class URLSessionHTTPClient: HTTPClient {
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    private struct UnexpectedValuesRepresentation: Error {}

    func post(from url: URL, payload: Data, completion: @escaping (HTTPClient.Result) -> Void) {
        session.dataTask(with: getRequest(from: url, payload: payload)) { data, response, error in
            if let error = error {
                completion(.failure(error))
            } else if let data = data, let response = response as? HTTPURLResponse {
                completion(.success((data, response)))
            } else {
                completion(.failure(UnexpectedValuesRepresentation()))
            }
        }.resume()
    }
    
    private func getRequest(from url: URL, payload: Data) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = payload

        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: HTTPHeaders.AcceptFieldKey)
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: HTTPHeaders.ContentTypeFieldKey)
        request.setValue("iOS", forHTTPHeaderField: HTTPHeaders.UserAgentKey)
        
        return request
    }
}
