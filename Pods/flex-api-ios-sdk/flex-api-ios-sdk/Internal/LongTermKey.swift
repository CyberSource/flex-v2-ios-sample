//
//  LongTermKey.swift
//  flex_api_ios_sdk
//
//  Created by Rakesh Ramamurthy on 13/04/21.
//

import Foundation

class LongTermKey {
    static let sharedInstance = LongTermKey()
    
    private var publicKeys = [String: SecKey]()
    
    private init() {
        initKeys()
    }
            
    private func initKeys() {
        //CAS
        //let cas3gKeyStr = RSAUtils.readKeys(fromFile: "3g")
        let cas3gKeyStr = """
-----BEGIN PUBLIC KEY-----
MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAir7Nl1Bj8G9rxr3co5v/
JLkP3o9UxXZRX1LIZFZeckguEf7Gdt5kGFFfTsymKBesm3Pe8o1hwfkq7KmJZEZS
uDbiJSZvFBZycK2pEeBjycahw9CqOweM7aKG2F/bhwVHrY4YdKsp/cSJe/ZMXFUq
Ymjk7D0p7clX6CmR1QgMl41Ajb7NHI23uOWL7PyfJQwP1X8HdunE6ZwKDNcavqxO
W5VuW6nfsGvtygKQxjeHrI+gpyMXF0e/PeVpUIG0KVjmb5+em/Vd2SbyPNmenADG
JGCmECYMgL5hEvnTuyAybwgVwuM9amyfFqIbRcrAIzclT4jQBeZFwkzZfQF7MgA6
QQIDAQAB
-----END PUBLIC KEY-----
"""
        publicKeys["3g"] = RSAUtils.rsaPublicKeyRef(fromBase64String: cas3gKeyStr,
                                                    withTag: "3g")?.takeRetainedValue()
        
        //let caszuKeyStr = RSAUtils.readKeys(fromFile: "zu")
        let caszuKeyStr = """
-----BEGIN PUBLIC KEY-----
MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAozmvkuGzWNHs9cEcC5PW
wbG+dmSjPcoQFxEbqH/fBjkj/nfTTKshdiSq5ciulWEa/rrqQ2qwcSADNxtTzRR1
qfud+NvsM8VltT7xDuVVqPTZoWLKa0BWXgQQ+1mCm1KdGltYWccB0R1LoF+rb3DE
EZySsHvqErYzYt4M/rqjEiK5Y9y1h3k1h5Yk4zGLWchko3jiDS+pVevvWsQsN+Y3
KuB19485G9P/MXLtfJWQ4wC4jlo9etdD/hgDfxX+hQy3wuwHfHifLdxvxiB8X5Is
4m6DuY4/7hS5RwXAjO1QSd+zUYZNT/2yWVR56/jyiZEiOdgIm9QtLPZCTKzqsXoq
ZQIDAQAB
-----END PUBLIC KEY-----
"""
        publicKeys["zu"] = RSAUtils.rsaPublicKeyRef(fromBase64String: caszuKeyStr,
                                                     withTag: "zu")?.takeRetainedValue()

        //PROD
        //let caslnKeyStr = RSAUtils.readKeys(fromFile: "ln")
        let caslnKeyStr = """
-----BEGIN PUBLIC KEY-----
MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAg1Rzx+fgWZRG85rr2BGD
EllGL1ktK5i9d1+5yXmP5BKm9jgXuNobr2QyBIZoii5yfkRiswpqkflARJl9kmkO
CFaZ0b5p0/h530V/DZyam9SrMfGST9jiNu7W7j/9iLHIVCRTeILeeW9/wBDWGeoE
ZCaBNIF+73zP08gzaQfEzvu37R2hqkk7MSh4HuWj8jXubUQYQxti89S1AfNoxKRY
cTNBb/xYP9AeczjowU4QZwxFVKXn6//vCL5419fGPH+YQtGaJePHE0+u/PKV0GZx
BzhR07DqjuuORmD6guLxejKAt/sSbvbVdJ7owhHYxZskVep1rfEekuSdxrHpJ6dm
0QIDAQAB
-----END PUBLIC KEY-----
"""
        publicKeys["ln"] = RSAUtils.rsaPublicKeyRef(fromBase64String: caslnKeyStr,
                                                     withTag: "ln")?.takeRetainedValue()
        
        //let caswfKeyStr = RSAUtils.readKeys(fromFile: "wf")
        let caswfKeyStr = """
-----BEGIN PUBLIC KEY-----
MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAmutlUOjmsHUaPlCyQCSr
xpH1fOFwUwHTCtB3lTVVcabVPaF3Cv+RYgLY47VjxwucRoNz5w6/Eupfw4MDqC2v
YOxHT5iCjyIZtm7EPWPsuJh/u2xBcRcez6lWrQuKx9h6Sf/uJFq7Xl6Edwv2/x2b
HcZSRyAsSawvVNeOnFcA3JT3ax7P26psE90CHG4/1O3IdsttGttY64ynNUxKj9hN
a/Iwgxu9fnaDbcObaT8v5AkfYD2l1j3J+s46g9OlMY6CZS0P8sDBkZ6C+7tIkB5N
LrMo88JfbRSshUSKZmhWiYgMHcxUgwDs3cunI2aWIEegQZwgDNyiQxV2Xd2aQr2B
EwIDAQAB
-----END PUBLIC KEY-----
"""
        publicKeys["wf"] = RSAUtils.rsaPublicKeyRef(fromBase64String: caswfKeyStr,
                                                     withTag: "wf")?.takeRetainedValue()
    }
    
    func get(kid: String) -> SecKey? {
        return publicKeys[kid]
    }
}
