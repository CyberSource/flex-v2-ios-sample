//
//  Constants.swift
//  flex-api-ios-sample-app
//
//  Created by Rakesh Ramamurthy on 17/05/21.
//

import Foundation

enum Environment {
    case sandbox
    case production
    
    var scheme: String {
        return "https://"
    }

    var host: String {
        switch self {
        case .sandbox:
            return "testflex.cybersource.com"
        case .production:
            return "flex.cybersource.com"
        }
    }
    
    var path: String {
        switch self {
        case .sandbox:
            return "/flex/v2/sessions"
        case .production:
            return "/flex/v2/sessions"
        }
    }
}
