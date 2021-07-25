//
//  PayloadUtility.swift
//  flex-api-ios-sample-app
//
//  Created by Rakesh Ramamurthy on 17/04/21.
//

import Foundation
import CommonCrypto

class PayloadUtility {
        
    func getSignedSignature(signatureStr: String, merchantSecretKey: String) -> String {
        let cKey = base64DecodeAsData(key: merchantSecretKey)
        let cData = signatureStr.cString(using: String.Encoding.utf8)
        let digestLen = Int(CC_SHA256_DIGEST_LENGTH)

        var result = [CUnsignedChar](repeating: 0, count: Int(digestLen))
        let strLen = Int(strlen(cData!))
        CCHmac(CCHmacAlgorithm(kCCHmacAlgSHA256), cKey.bytes, cKey.length, cData!, strLen, &result)
        let hmacData:NSData = NSData(bytes: result, length: digestLen)
        let hmacBase64 = hmacData.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        return String(hmacBase64)
    }

    
    func base64DecodeAsData(key: String) -> NSData {
        let decodedData = NSData(base64Encoded: key, options: NSData.Base64DecodingOptions(rawValue: 0))
        return decodedData!
    }

    func getDigest(_ messageBody: String) -> String? {
        guard
            let data = messageBody.data(using: String.Encoding.utf8),
            let shaData = sha256(data)
            else { return nil }
        var rc = shaData.base64EncodedString(options: [])
        
        rc = "SHA-256" + "=" + rc

        return rc
    }
    
    private func sha256(_ data: Data) -> Data? {
        guard let res = NSMutableData(length: Int(CC_SHA256_DIGEST_LENGTH)) else { return nil }
        CC_SHA256((data as NSData).bytes, CC_LONG(data.count), res.mutableBytes.assumingMemoryBound(to: UInt8.self))
        return res as Data
    }
    
    let iso8601Formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "E, d MMM yyyy HH:mm:ss Z"
        return formatter
    }()
    
    func iso8601() -> (full: String, short: String) {
        let date = iso8601Formatter.string(from: Date())
        let index = date.index(date.startIndex, offsetBy: 8)
        let shortDate = date.substring(to: index)
        return (full: date, short: shortDate)
    }

}
