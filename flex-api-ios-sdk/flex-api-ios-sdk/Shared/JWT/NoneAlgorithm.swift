//
//  NoneAlgorithm.swift
//  flex_api_ios_sdk
//
//  Created by Rakesh Ramamurthy on 15/04/21.
//

import Foundation

struct NoneAlgorithm: VerifierAlgorithm {
    
    let name: String = "none"
        
    func verify(jwt: String) -> Bool {
        return true
    }
}
