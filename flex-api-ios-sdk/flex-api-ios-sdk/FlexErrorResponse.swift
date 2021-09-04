//
//  FlexErrorResponse.swift
//  flex_api_ios_sdk
//
//  Created by Rakesh Ramamurthy on 22/04/21.
//

import Foundation

public class FlexErrorResponse: Equatable, Decodable, Error {
    public static func == (lhs: FlexErrorResponse, rhs: FlexErrorResponse) -> Bool {
        lhs.responseStatus == rhs.responseStatus
    }
    
    public let responseStatus: ResponseStatus
        
    public init(status: ResponseStatus) {
        self.responseStatus = status
    }
}

public class ResponseStatus: Equatable, Decodable {
    public static func == (lhs: ResponseStatus, rhs: ResponseStatus) -> Bool {
        lhs.status == rhs.status &&
        lhs.reason == rhs.reason &&
        lhs.message == rhs.message &&
        lhs.domain == rhs.domain &&
        lhs.correlationId == rhs.correlationId &&
        lhs.details == rhs.details
    }
    
    public let status: Int
    public let reason: String
    public let message: String
    public let domain: String?

    public let correlationId: String?
    public var details: [ResponseStatusDetail]? = [ResponseStatusDetail]()
    
    init(status: Int, reason: String, message: String, domain: String? = nil, correlationId: String? = nil, details: [ResponseStatusDetail]? = nil) {
        self.status = status
        self.reason = reason
        self.message = message
        self.correlationId = correlationId
        self.details = details
        self.domain = domain
    }
}

public class ResponseStatusDetail: Equatable, Decodable {
    public static func == (lhs: ResponseStatusDetail, rhs: ResponseStatusDetail) -> Bool {
        lhs.location == rhs.location &&
        lhs.message == rhs.message
    }
    
    public let location: String
    public let message: String
    
    init(location: String, message: String) {
        self.location = location
        self.message = message
    }
}
