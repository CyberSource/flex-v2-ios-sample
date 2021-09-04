//
//  Tools.swift
//  flex_api_ios_sdk
//
//  Created by Rakesh Ramamurthy on 22/04/21.
//

import Foundation

class Tools {
    
    static func handleErrorResponse(response: HttpResponse, startTime: Int64) -> FlexErrorResponse {
        if let data = response.body?.data(using: .utf8) {
            do {
                let error = try JSONDecoder().decode(FlexErrorResponse.self, from: data)
                return error
            } catch {
                return getGenericError()
            }
        }
        
        return getGenericError()
    }
    
    static func getGenericError() -> FlexErrorResponse {
        let error = ResponseStatus(status: 5000, reason: "Unknown", message: "Some thing went wrong", correlationId: nil, details: nil)
        return FlexErrorResponse(status: error)
    }
    
    static func createErrorObjectFrom(status: Int, reason: String, message: String) -> FlexErrorResponse {
        let error = ResponseStatus(status: status, reason: reason, message: message, correlationId: nil, details: nil)
        return FlexErrorResponse(status: error)
    }
}
