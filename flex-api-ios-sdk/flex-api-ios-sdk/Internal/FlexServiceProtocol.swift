//
//  FlexServiceProtocol.swift
//  flex_api_ios_sdk
//
//  Created by Rakesh Ramamurthy on 13/04/21.
//

import Foundation

protocol FlexServiceProtocol {
    func flexPublicKey(kid: String) -> SecKey?
}
