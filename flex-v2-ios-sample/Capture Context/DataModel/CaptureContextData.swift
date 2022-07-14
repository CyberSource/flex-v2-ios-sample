//
//  FlexCardData.swift
//  flex-api-ios-sample-app
//
//  Created by Rakesh Ramamurthy on 17/03/21.
//

import Foundation

class FlexCardData: Codable {
    var number: FlexFieldData?
    var securityCode: FlexFieldData?
    var expirationMonth: FlexFieldData?
    var expirationYear: FlexFieldData?
    var type: FlexFieldData?
}

class FlexFieldData: Codable {
    var required: Bool

    init(isRequired: Bool) {
        self.required = isRequired
    }
}

class FlexPaymentInfo: Codable {
    var card: FlexCardData
    
    init(data: FlexCardData) {
        self.card = data
    }
}

class FlexSessionFields: Codable {
    var paymentInformation: FlexPaymentInfo
    
    init(info: FlexPaymentInfo) {
        self.paymentInformation = info
    }
}

class FlexSessionRequest: Codable {
    var fields: FlexSessionFields
    
    init(fields: FlexSessionFields) {
        self.fields = fields
    }
}
