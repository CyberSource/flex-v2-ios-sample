//
//  FlexServiceErrors.swift
//  flex_api_ios_sdk
//
//  Created by Rakesh Ramamurthy on 30/04/21.
//

import Foundation

enum FlexInternalErrors {
    case jwtSignatureValidationError
    case jwtDateValidationError
    case emptyCaptureContext
    case emptyCardData
    case invalidFlexServiceOrigin
    case invalidFlexServicePath
    case invalidFlexServiceURL
    case requestObjectDecodingError
    case missingKid
    case missingDigestHeader
    case digestHeaderLengthMismatch
    case digestEncodingError
    case digestMismatch
    case jwePayloadSerializationError
    case jweEncryptorError
    case jweInvalidPublicKey
    case jweCreationError

    case unknownError

    private var domain: String {
        return "com.visa.flexios"
    }

    private var errorCode: Int {
        switch self {
        case .jwtSignatureValidationError:
            return 100
        case .jwtDateValidationError:
            return 101
        case .emptyCaptureContext:
            return 1000
        case .emptyCardData:
            return 1001
        case .invalidFlexServiceOrigin:
            return 1002
        case .invalidFlexServicePath:
            return 1003
        case .invalidFlexServiceURL:
            return 1004
        case .requestObjectDecodingError:
            return 1005
        case .missingKid:
            return 1005
        case .missingDigestHeader:
            return 3000
        case .digestHeaderLengthMismatch:
            return 3001
        case .digestEncodingError:
            return 3002
        case .digestMismatch:
            return 3003
        case .jwePayloadSerializationError:
            return 3100
        case .jweEncryptorError:
            return 3101
        case .jweInvalidPublicKey:
            return 3102
        case .jweCreationError:
            return 3103

        case .unknownError:
            return 1009
        }
    }
    
    var message: String {
        switch self {
        case .jwtSignatureValidationError:
            return "There is no internet connection"
        case .jwtDateValidationError:
            return "JWT date validation failed"
        case .emptyCaptureContext:
            return "Invalid capture context"
        case .emptyCardData:
            return "Please provide valid data"
        case .invalidFlexServiceOrigin:
            return "Invalid flex service origin"
        case .invalidFlexServicePath:
            return "Invalid flex service path"
        case .invalidFlexServiceURL:
            return "Invalid flex service URL"
        case .requestObjectDecodingError:
            return "Error while creating request"
        case .missingKid:
            return "KID is missing"
        case .missingDigestHeader:
            return "Could not verify response digest, missing digest header"
        case .digestHeaderLengthMismatch:
            return "Could not verify response digest: invalid digest length"
        case .digestEncodingError:
            return "Error while encoding response digest"
        case .digestMismatch:
            return "Response digest mismatch"
        case .jwePayloadSerializationError:
            return "JWE: Error while serializing payload data"
        case .jweEncryptorError:
            return "JWE: Error while initializing encryptor"
        case .jweInvalidPublicKey:
            return "JWE: Error extracting public key"
        case .jweCreationError:
            return "JWE: Error while constructing jwe"

        case .unknownError:
            return "Unknown error, please try again later."
        }
    }
    
    var reason: String {
        switch self {
        case .jwtSignatureValidationError:
            return "There is no internet connection"
        case .jwtDateValidationError:
            return "Expired/Invalid token"
        case .emptyCaptureContext:
            return "Empty capture context"
        case .emptyCardData:
            return "Empty card data"
        case .invalidFlexServiceOrigin:
            return "Provide valid origin"
        case .invalidFlexServicePath:
            return "Provide valid path"
        case .invalidFlexServiceURL:
            return "Provide valid URL"
        case .requestObjectDecodingError:
            return "Invalid request"
        case .missingKid:
            return "Invalid KID"
        case .missingDigestHeader:
            return "Invalid digest"
        case .digestHeaderLengthMismatch:
            return "Invalid digest length"
        case .digestEncodingError:
            return "Invalid digest"
        case .digestMismatch:
            return "Invalid digest"
        case .jwePayloadSerializationError:
            return "Payload serialization error"
        case .jweEncryptorError:
            return "Invalid Encryptor"
        case .jweInvalidPublicKey:
            return "Invalid Public key"
        case .jweCreationError:
            return "Invalid JWE"

        case .unknownError:
            return "Unknown error"
        }
    }

    var errorResponse: FlexErrorResponse {
        let errorResponse = ResponseStatus(status: errorCode, reason: reason, message: message, domain: domain)
        return FlexErrorResponse(status: errorResponse)
    }
}
