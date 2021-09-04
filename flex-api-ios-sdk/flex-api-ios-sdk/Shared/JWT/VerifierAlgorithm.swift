//
//  VerifierAlgorithm.swift
//  flex_api_ios_sdk
//
//  Created by Rakesh Ramamurthy on 15/04/21.
//

import Foundation

protocol VerifierAlgorithm {
    /// A function to verify the signature of a JSON web token string is correct for the header and claims.
    func verify(jwt: String) -> Bool
    
}
