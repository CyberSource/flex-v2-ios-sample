//
//  LongTermKey.swift
//  flex_api_ios_sdk
//
//  Created by Rakesh Ramamurthy on 13/04/21.
//

import Foundation
import CybersourceFlexSDKPrivate

class LongTermKey {
    static let sharedInstance = LongTermKey()
    
    private var publicKeys = [String: SecKey]()
    
    private init() {
        initKeys()
    }
            
    private func initKeys() {
        //CAS
        let cas3gKeyStr = RSAUtils.readKeys(fromFile: "3g")
        publicKeys["3g"] = RSAUtils.rsaPublicKeyRef(fromBase64String: cas3gKeyStr,
                                                    withTag: "3g")?.takeRetainedValue()
        
        let caszuKeyStr = RSAUtils.readKeys(fromFile: "zu")
        publicKeys["zu"] = RSAUtils.rsaPublicKeyRef(fromBase64String: caszuKeyStr,
                                                     withTag: "zu")?.takeRetainedValue()

        //PROD
        let caslnKeyStr = RSAUtils.readKeys(fromFile: "ln")
        publicKeys["ln"] = RSAUtils.rsaPublicKeyRef(fromBase64String: caslnKeyStr,
                                                     withTag: "ln")?.takeRetainedValue()
        
        let caswfKeyStr = RSAUtils.readKeys(fromFile: "wf")
        publicKeys["wf"] = RSAUtils.rsaPublicKeyRef(fromBase64String: caswfKeyStr,
                                                     withTag: "wf")?.takeRetainedValue()
    }
    
    func get(kid: String) -> SecKey? {
        return publicKeys[kid]
    }
}
