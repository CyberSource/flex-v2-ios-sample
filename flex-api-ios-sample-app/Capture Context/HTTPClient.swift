//
//  HTTPClient.swift
//  flex-api-ios-sample-app
//
//  Created by Rakesh Ramamurthy on 17/03/21.
//

import Foundation

enum HTTPClientResult {
    case success(Data, HTTPURLResponse)
    case failure(Error)
}

protocol HTTPClient {
    func post(from url: URL, payload: Data, headers: [String: String], completion: @escaping (HTTPClientResult) -> Void)
}
