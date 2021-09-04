//
//  DigestHelper.swift
//  flex_api_ios_sdk
//
//  Created by Rakesh Ramamurthy on 22/04/21.
//

import Foundation
import CommonCrypto

class DigestHelper {
    
    static func verifyResponseDigest(response: HttpResponse) throws {
        guard let digestHeader = response.getValue(for: "Digest") else {
            throw FlexInternalErrors.missingDigestHeader.errorResponse
        }

        if digestHeader.starts(with: "SHA-256=") {
            let delimiterIndex = digestHeader.firstIndex(of: "=")
            let index: Int = digestHeader.distance(from: digestHeader.startIndex, to: delimiterIndex!)

            let digestHeaderLength = digestHeader.count
            if (index == digestHeaderLength - 1) {
                throw FlexInternalErrors.digestHeaderLengthMismatch.errorResponse
            }
            
            let startIndex = digestHeader.index(delimiterIndex!, offsetBy: 1)

            let digestValue = String(digestHeader[startIndex..<digestHeader.endIndex])

            guard let data = response.body?.data(using: String.Encoding.utf8),
                  let calculatedDigest = sha256(data)?.base64EncodedString() else {
                throw FlexInternalErrors.digestEncodingError.errorResponse
            }
            
            if digestValue != calculatedDigest {
                throw FlexInternalErrors.digestMismatch.errorResponse
            }
        }
    }
    
    static func sha256(_ data: Data) -> Data? {
        guard let res = NSMutableData(length: Int(CC_SHA256_DIGEST_LENGTH)) else { return nil }
        CC_SHA256((data as NSData).bytes, CC_LONG(data.count), res.mutableBytes.assumingMemoryBound(to: UInt8.self))
        return res as Data
    }
}
