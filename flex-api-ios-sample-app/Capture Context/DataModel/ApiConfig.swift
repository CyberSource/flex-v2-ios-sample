//
//  ApiConfig.swift
//  flex-api-ios-sample-app
//
//  Created by Rakesh Ramamurthy on 17/03/21.
//

import Foundation

class ApiConfig {
    var merchantID: String
    var merchantKeyId: String
    var merchantSecretKey: String
    var requestTarget: String
    var requestUrlScheme: String
    var requestHost: String
    var requestData: String?

    init(id: String, key: String, secret: String, env: Environment) {
        self.merchantID = id
        self.merchantKeyId = key
        self.merchantSecretKey = secret
        self.requestTarget = env.path
        self.requestUrlScheme = env.scheme
        self.requestHost = env.host
    }
}
