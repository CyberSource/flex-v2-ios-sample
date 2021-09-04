//
//  DataConvertible.swift
//  flex_api_ios_sdk
//
//  Created by Rakesh Ramamurthy on 19/04/21.
//

import Foundation

protocol DataConvertible {
    init?(_ data: Data)
    func data() -> Data
}
