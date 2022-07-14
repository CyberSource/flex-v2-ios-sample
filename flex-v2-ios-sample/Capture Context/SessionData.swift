//
//  SessionData.swift
//  flex-api-ios-sample-app
//
//  Created by Rakesh Ramamurthy on 17/03/21.
//

import Foundation

struct SessionData: Equatable {
    let keyId: String?
    
    init(keyId: String?) {
        self.keyId = keyId
    }
}
