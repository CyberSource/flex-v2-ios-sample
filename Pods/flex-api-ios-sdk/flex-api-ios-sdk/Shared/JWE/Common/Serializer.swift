//
//  Serializer.swift
//  flex_api_ios_sdk
//
//  Created by Rakesh Ramamurthy on 19/04/21.
//

import Foundation

protocol CompactSerializable {
    func serialize(to serializer: inout CompactSerializer)
}

protocol CompactSerializer {
    var components: [DataConvertible] { get }
    mutating func serialize<T: DataConvertible>(_ object: T)
}

struct JWESerializer {
    func serialize<T: CompactSerializable>(compact object: T) -> String {
        var serializer: CompactSerializer = _CompactSerializer()
        object.serialize(to: &serializer)
        let base64URLEncodings = serializer.components.map { component in component.data().base64URLEncodedString() }
        return base64URLEncodings.joined(separator: ".")
    }
}

private struct _CompactSerializer: CompactSerializer {
    var components: [DataConvertible] = []

    mutating func serialize<T: DataConvertible>(_ object: T) {
        components.append(object)
    }
}
