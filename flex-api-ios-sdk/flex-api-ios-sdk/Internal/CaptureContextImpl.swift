//
//  CaptureContextImpl.swift
//  flex_api_ios_sdk
//
//  Created by Rakesh Ramamurthy on 11/04/21.
//

import Foundation
import CryptoKit

class CaptureContextImpl {
    var src: String
    var jwt: JWT<JWTClaims>

    init(from jwt: String) throws {
        self.src = jwt
        
        let rsaJWTDecoder = JWTDecoder(jwtVerifier: .none)
        self.jwt = try rsaJWTDecoder.decode(JWT<JWTClaims>.self, fromString: jwt)
        print(self.jwt.claims.exp as Any)
        print(self.jwt.claims.iat as Any)

        guard let issuedAt = self.jwt.claims.iat,
              let expireAt = self.jwt.claims.exp,
              self.jwt.validateClaims(expDate: expireAt, iatDate: issuedAt) == .success else {
            throw FlexInternalErrors.jwtDateValidationError.errorResponse
        }
        
        guard let kid = self.jwt.header.kid,
              let publicKey = LongTermKey.sharedInstance.get(kid: kid),
              JWT<JWTClaims>.self.verify(jwt, using: .rs256(publicKey: publicKey)) else {
            throw FlexInternalErrors.jwtSignatureValidationError.errorResponse
        }
    }    
}

extension CaptureContextImpl: CaptureContext {
    
    //TODO: remove all force unwrapping
    func getPublicKey() throws -> SecKey? {
        let flexPublicKey = getJsonWebKey()
        
        guard var nStr = flexPublicKey?.n,
              let eStr = flexPublicKey?.e else {
            throw FlexInternalErrors.jweInvalidPublicKey.errorResponse
        }
          
        //Padding required
        nStr = nStr.replacingOccurrences(of: "-", with: "+").replacingOccurrences(of: "_", with: "/")
          if nStr.count % 4 == 2 {
           nStr.append("==")
          }
          if nStr.count % 4 == 3 {
           nStr.append("=")
          }
          let nBytes = Data(base64Encoded: nStr)
          /*Same with e*/
          let eBytes = Data(base64Encoded: eStr)
          
        //Now this bytes we have to append such that [48, 130, 1, 10, 2, 130, 1, 1, 0, /* nBytes */, 0x02 , 0x03 ,/* eBytes */ ]
        var padding1 = Data([0x030,0x82,0x01,0x0a,0x02,0x82,0x01,0x01])
        let padding2 = Data([0x02,0x03])
        if nBytes?[0] != 0 {
            padding1.append([0x00], count: 1)
        }
        var keyData = Data(padding1)
        keyData.append(nBytes!)
        keyData.append(padding2)
        keyData.append(eBytes!)
        let attributes: [String: Any] = [
                    kSecAttrKeyType as String: kSecAttrKeyTypeRSA,
                    kSecAttrKeyClass as String: kSecAttrKeyClassPublic,
                    kSecAttrKeySizeInBits as String: 2048,
                    kSecAttrIsPermanent as String: false
                ]
                var error: Unmanaged<CFError>?
        let keyReference = SecKeyCreateWithData(keyData as CFData, attributes as CFDictionary, &error)!
        
        return keyReference
    }

    func getFlexOrigin() -> String? {
        let flx = jwt.claims.flx?.origin
        return flx
    }
    
    func getTokensPath() -> String? {
        let path = jwt.claims.flx?.path
        return path
    }
    
    func getJsonWebKey() -> JwkClaim? {
        return jwt.claims.flx?.jwk
    }
    
    func jwe(kid: String, data: [String: Any]) throws -> String? {
        var header = JWEHeader(keyManagementAlgorithm: .RSAOAEP, contentEncryptionAlgorithm: .A256GCM)
        header.kid = kid

        var payloadDict = [String: Any]()
        payloadDict["context"] = self.src
        payloadDict["data"] = data
        payloadDict["index"] = 0
        let milliSeconds = Date().timeIntervalSince1970 / 1000
        payloadDict["iat"] = milliSeconds
        payloadDict["jti"] = String.randomString(of: 32)

        var payloadData: Data?
        do {
            payloadData = try JSONSerialization.data(withJSONObject: payloadDict, options: .prettyPrinted)
        } catch {
            throw FlexInternalErrors.jwePayloadSerializationError.errorResponse
        }

        if let data = payloadData {

            let payload = Payload(data)
            
            let publicKey: SecKey?
            do {
                publicKey = try getPublicKey()
            } catch let error as FlexErrorResponse {
                throw error
            }
            
            guard let pk = publicKey,
                let encrypter = Encrypter(keyManagementAlgorithm: .RSAOAEP, contentEncryptionAlgorithm: .A256GCM, encryptionKey: pk) else {
                throw FlexInternalErrors.jweEncryptorError.errorResponse
            }

            var jwe: JWE?
            do {
                jwe = try JWE(header: header, payload: payload, encrypter: encrypter)
            } catch let error as FlexErrorResponse {
                throw error
            }

            let serialization = jwe?.compactSerializedString
            return serialization
        }

        return nil
    }
}

extension String {
    func toBase64URL() -> String {
        var result = Data(self.utf8).base64EncodedString()
        result = result.replacingOccurrences(of: "+", with: "-")
        result = result.replacingOccurrences(of: "/", with: "_")
        result = result.replacingOccurrences(of: "=", with: "")
        return result
    }
    
    static func randomString(of length: Int) -> String {
        let letters = "1234567890AaBbCcDdEeFfGg"
        var s = ""
        for _ in 0 ..< length {
            s.append(letters.randomElement()!)
        }
        return s
   }
}
