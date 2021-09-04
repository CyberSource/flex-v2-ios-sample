//
//  RemoteFlexToken.swift
//  flex_api_ios_sdk
//
//  Created by Rakesh Ramamurthy on 05/04/21.
//

import Foundation

struct RemoteFlexToken: Decodable, Equatable {
    let token: String
    let timestamp: Int64
    
    init(token: String, timestamp: Int64) {
        self.token = token
        self.timestamp = timestamp
    }
}
