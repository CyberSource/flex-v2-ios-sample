//
//  PayloadDigest.swift
//  flex-api-ios-sample-app
//
//  Created by Rakesh Ramamurthy on 17/04/21.
//

import Foundation

class PayloadDigest {
    private let merchantConfig: ApiConfig
    private var messageBody: String?

    init(merchantConfig: ApiConfig) {
        self.merchantConfig = merchantConfig
    }

    func getDigest() -> String? {
        return digestGeneration()
    }
    
    private func digestGeneration() -> String? {
        /*
         * This method return Digest value which is SHA-256 hash of payload that
         * is BASE64 encoded
         */

        let messageBody = payloadGeneration()
        let digestString = PayloadUtility().getDigest(messageBody!)

        return digestString
    }

    private func payloadGeneration() -> String? {
        messageBody = self.merchantConfig.requestData
        return messageBody
    }
}
