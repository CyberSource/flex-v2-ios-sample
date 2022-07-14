//
//  ValidateClaimsResult.swift
//  flex_api_ios_sdk
//
//  Created by Rakesh Ramamurthy on 15/04/21.
//

import Foundation

struct ValidateClaimsResult: CustomStringConvertible, Equatable {
    
    /// The human readable description of the ValidateClaimsResult
    let description: String
    
    /// Successful validation.
    static let success = ValidateClaimsResult(description: "Success")

    /// Invalid Expiration claim.
    static let invalidExpiration = ValidateClaimsResult(description: "Invalid Expiration claim")
    
    /// Expired token: expiration time claim is in the past.
    static let expired = ValidateClaimsResult(description: "Expired token")
    
    /// Invalid Not Before claim.
    static let invalidNotBefore = ValidateClaimsResult(description: "Invalid Not Before claim")
    
    /// Not Before claim is in the future.
    static let notBefore = ValidateClaimsResult(description: "Token is not valid yet, Not Before claim is greater than the current time")
    
    /// Invalid Issued At claim.
    static let invalidIssuedAt = ValidateClaimsResult(description: "Invalid Issued At claim")
    
    /// Issued At claim is in the future.
    static let issuedAt = ValidateClaimsResult(description: "Issued At claim is greater than the current time")
 
    /// Check if two ValidateClaimsResults are equal. Required for the Equatable protocol
    static func == (lhs: ValidateClaimsResult, rhs: ValidateClaimsResult) -> Bool {
        return lhs.description == rhs.description
    }
}
