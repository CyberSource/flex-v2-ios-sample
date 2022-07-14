//
//  FlexRequest.swift
//  flex_api_ios_sdk
//
//  Created by Rakesh Ramamurthy on 19/04/21.
//

import Foundation

class FlexRequest: Codable {
    let keyId: String
    
    init(keyId: String) {
        self.keyId = keyId
    }
}
