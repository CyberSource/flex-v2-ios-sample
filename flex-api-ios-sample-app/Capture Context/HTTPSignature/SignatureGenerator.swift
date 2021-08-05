//
//  SignatureGenerator.swift
//  flex-api-ios-sample-app
//
//  Created by Rakesh Ramamurthy on 17/04/21.
//

import Foundation

class SignatureGenerator {
    private let merchantConfig: ApiConfig
    private let payloadUtility: PayloadUtility

    init(merchantConfig: ApiConfig) {
        self.merchantConfig = merchantConfig
        self.payloadUtility = PayloadUtility()
    }

    func getSignature() -> String? {
        var signatureString = String()
        
        signatureString.append("\n")
        signatureString.append("\(Constants.HOST.lowercased())")
        signatureString.append(": ")
        signatureString.append("\(merchantConfig.requestHost)")
        signatureString.append("\n")
        signatureString.append("\(Constants.DATE.lowercased())")
        signatureString.append(": ")
        
        let date = self.payloadUtility.iso8601()
        signatureString.append(date.full)

        signatureString.append("\n")
        signatureString.append("(request-target)")
        signatureString.append(": ")
        signatureString.append("\(getRequestTarget(requestType: Constants.POST))")

        signatureString.append("\n")

        signatureString.append("\(Constants.DIGEST.lowercased())")
        signatureString.append(": ")
        signatureString.append(PayloadDigest(merchantConfig: merchantConfig).getDigest()!)
        signatureString.append("\n")

        signatureString.append("\(Constants.V_C_MERCHANTID)")
        signatureString.append(": ")
        signatureString.append("\(merchantConfig.merchantID)")
        
        signatureString.removeFirst()

        let signatureParameterBase64Encoded = self.payloadUtility.getSignedSignature(signatureStr: signatureString, merchantSecretKey: self.merchantConfig.merchantSecretKey)
        
        return signatureParameterBase64Encoded
    }
    
    private func getRequestTarget(requestType: String) -> String {
        var requestTarget: String
        
        switch requestType {
        case "POST":
            requestTarget = "\(Constants.POST.lowercased())" + " " + "\(merchantConfig.requestTarget)"
        default:
            requestTarget = ""
        }
        
        return requestTarget

    }    
}
