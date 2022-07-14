//
//  HTTPSignature.swift
//  flex-api-ios-sample-app
//
//  Created by Rakesh Ramamurthy on 17/04/21.
//

import Foundation

class HTTPSignature {
    private let merchantConfig: ApiConfig

    init(merchantConfig: ApiConfig) {
        self.merchantConfig = merchantConfig
    }
    
    func getHTTPSignature() -> String? {
        let signature = signatureHeaders()
        return signature
    }
    
    private func signatureHeaders() -> String {
        var signatureHeader = String()

        signatureHeader.append("keyid=\"\(merchantConfig.merchantKeyId)\"")
        signatureHeader.append(", algorithm=\"HmacSHA256\"")
        signatureHeader.append(", headers=\"\(getRequestHeaders(requestType: "POST"))\"")

        if let signatureValue = SignatureGenerator(merchantConfig: self.merchantConfig).getSignature() {
            signatureHeader.append(", signature=\"\(signatureValue)\"")
        } else {
            //print("Invalid signature....")
        }
        
        //Signature header
        return signatureHeader
    }
    
    private func getRequestHeaders(requestType: String) -> String {
        var requestHeader: String
        
        switch requestType {
        case "POST":
            requestHeader = "host date (request-target) digest v-c-merchant-id"
        default:
            requestHeader = ""
        }
        
        return requestHeader
    }
}
