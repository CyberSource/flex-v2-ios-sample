//
//  RSAAlgorithm.swift
//  flex_api_ios_sdk
//
//  Created by Rakesh Ramamurthy on 30/04/21.
//

import Foundation

struct RSAAlgorithm: VerifierAlgorithm {
    
    let name: String = "RSA"
        
    private let key: SecKey
    private let keyType: RSAKeyType
    //private let algorithm: Data.Algorithm
    private let usePSS: Bool
    
    init(key: SecKey, keyType: RSAKeyType?=nil, usePSS: Bool = false) {
        self.key = key
        self.keyType = keyType ?? .publicKey
        //self.algorithm = algorithm
        self.usePSS = usePSS
    }

    func verify(jwt: String) -> Bool {
        let components = jwt.components(separatedBy: ".")
        if components.count == 3 {
            guard let signature = JWTDecoder.data(base64urlEncoded: components[2]),
                let jwtData = (components[0] + "." + components[1]).data(using: .utf8)
                else {
                    return false
            }
            return self.verify(signature: signature, for: jwtData)
        } else {
            return false
        }
    }
    
    func verify(signature: Data, for data: Data) -> Bool {
        let verified = SecKeyVerifySignature(self.key, .rsaSignatureMessagePKCS1v15SHA256, data as CFData, signature as CFData, nil)
        
        return verified
    }

}
