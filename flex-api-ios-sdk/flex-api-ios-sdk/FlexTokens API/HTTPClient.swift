//
//  HTTPClient.swift
//  flex_api_ios_sdk
//
//  Created by Rakesh Ramamurthy on 03/04/21.
//

import Foundation

protocol HTTPClient {
    /// The completion handler can be invoked in any thread.
    /// Clients are responsible to dispatch to appropriate threads, if needed.
    typealias Result = Swift.Result<(Data, HTTPURLResponse), Error>

    func post(from url: URL, payload: Data, completion: @escaping (Result) -> Void)
}
