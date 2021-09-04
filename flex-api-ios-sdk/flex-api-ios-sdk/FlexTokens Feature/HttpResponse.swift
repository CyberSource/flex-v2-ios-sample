//
//  FlexTransientTokenResponse.swift
//  flex_api_ios_sdk
//
//  Created by Rakesh Ramamurthy on 05/04/21.
//

import Foundation

struct HttpResponse: Equatable {
    static func == (lhs: HttpResponse, rhs: HttpResponse) -> Bool {
        return lhs.status == rhs.status && lhs.body == rhs.body
    }
    
    let status: Int
    let body: String?
    let headers: [AnyHashable: Any]?

    init(status: Int, body: String?, headers: [AnyHashable: Any]?) {
        self.status = status
        self.body = body
        self.headers = headers
    }
    
    func isValidResponse() -> Bool {
        (200...299).contains(self.status)
    }
    
    func getValue(for key: String) -> String? {
        if let field = self.headers?[key.lowercased()] as? String {
             return field
         }
        
        return nil
    }
}
