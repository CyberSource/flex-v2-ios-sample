//
//  Claims.swift
//  flex_api_ios_sdk
//
//  Created by Rakesh Ramamurthy on 15/04/21.
//

import Foundation

protocol Claims: Codable {
    
    /**
     The "exp" (expiration time) claim identifies the expiration time on
     or after which the JWT MUST NOT be accepted for processing.  The
     processing of the "exp" claim requires that the current date/time
     MUST be before the expiration date/time listed in the "exp" claim.
     Implementers MAY provide for some small leeway, usually no more than
     a few minutes, to account for clock skew.
     */
    var exp: Date? { get }
    
    /**
     The "nbf" (not before) claim identifies the time before which the JWT
     MUST NOT be accepted for processing.  The processing of the "nbf"
     claim requires that the current date/time MUST be after or equal to
     the not-before date/time listed in the "nbf" claim.  Implementers MAY
     provide for some small leeway, usually no more than a few minutes, to
     account for clock skew.
     */
    var nbf: Date? { get }
    
    /**
     The "iat" (issued at) claim identifies the time at which the JWT was
     issued.  This claim can be used to determine the age of the JWT.
     */
    var iat: Date? { get }
    
    /// Encode the Claim object as a Base64 String.
    //func encode() throws -> String
}

extension Claims {
    
    var exp: Date? {
        return nil
    }
    
    var nbf: Date? {
        return nil
    }
    
    var iat: Date? {
        return nil
    }
}
