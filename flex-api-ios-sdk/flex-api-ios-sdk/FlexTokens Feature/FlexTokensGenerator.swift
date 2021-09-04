//
//  FlexTokensGenerator.swift
//  flex_api_ios_sdk
//
//  Created by Rakesh Ramamurthy on 03/04/21.
//

import Foundation

protocol FlexTokensGenerator {
    typealias Result = Swift.Result<HttpResponse, Error>

    func generateTransientToken(url: URL, payload: Data, completion: @escaping (Result) -> Void)
}
