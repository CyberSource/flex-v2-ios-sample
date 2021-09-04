//
//  AlgorithmExtensions.swift
//  flex_api_ios_sdk
//
//  Created by Rakesh Ramamurthy on 19/04/21.
//

import Foundation

extension ContentEncryptionAlgorithm {
   var keyLength: Int {
       switch self {
       case .A256GCM:
            return 32
       }
   }

   var initializationVectorLength: Int {
       switch self {
       case .A256GCM:
            return 12
       }
   }

   func checkKeyLength(for key: Data) -> Bool {
       switch self {
       case .A256GCM:
        return key.count == 32
       }
   }

   func retrieveKeys(from inputKey: Data) throws -> (hmacKey: Data, encryptionKey: Data) {
       switch self {
       case .A256GCM:
            guard checkKeyLength(for: inputKey) else {
                throw JWEError.keyLengthNotSatisfied
            }

            //TODO: not sure about this
            return (inputKey.subdata(in: 0..<32), inputKey.subdata(in: 0..<32))
       }
   }
}
