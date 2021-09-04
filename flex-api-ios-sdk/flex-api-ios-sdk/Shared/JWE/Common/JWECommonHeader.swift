//
//  JWECommonHeader.swift
//  flex_api_ios_sdk
//
//  Created by Rakesh Ramamurthy on 19/04/21.
//

import Foundation

enum HeaderParsingError: Error {
    case requiredHeaderParameterMissing(parameter: String)
    case headerIsNotValidJSONObject
}

/// A `JWEHeader` is a JSON object representing various Header Parameters.
/// Moreover, a `JWEHeader` is a `JWEObjectComponent`. Therefore it can be initialized from and converted to `Data`.
protocol JWECommonHeader: DataConvertible, CommonHeaderParameterSpace {
    var headerData: Data { get }
    var parameters: [String: Any] { get }

    init(parameters: [String: Any], headerData: Data) throws

    init?(_ data: Data)
    func data() -> Data
}

// `DataConvertible` implementation.
extension JWECommonHeader {
    init?(_ data: Data) {
        // Verify that the header is a completely valid JSON object.
        guard
            let json = try? JSONSerialization.jsonObject(with: data, options: []),
            let parameters = json as? [String: Any]
        else {
            return nil
        }

        try? self.init(parameters: parameters, headerData: data)
    }

    func data() -> Data {
        return headerData
    }
}

/// JWS and JWE share a common Header Parameter space that both JWS and JWE headers must support.
/// Those header parameters may have a different meaning depending on whether they are part of a JWE or JWS.
protocol CommonHeaderParameterSpace {
    var jwk: String? { get set }
    var kid: String? { get set }
}
