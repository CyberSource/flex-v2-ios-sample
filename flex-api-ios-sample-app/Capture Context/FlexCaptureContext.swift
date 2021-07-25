//
//  FlexCaptureContext.swift
//  flex-api-ios-sample-app
//
//  Created by Rakesh Ramamurthy on 17/03/21.
//

import Foundation

enum FlexCaptureContextResult {
    case success(SessionData)
    case failure(Error)
}

protocol FlexCaptureContext {
    func createCaptureContext(completion: @escaping (FlexCaptureContextResult) -> Void)
}
