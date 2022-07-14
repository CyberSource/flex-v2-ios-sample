//
//  Payload.swift
//  flex_api_ios_sdk
//
//  Created by Rakesh Ramamurthy on 19/04/21.
//

import Foundation

struct Payload: DataConvertible {
    let payload: Data

    init(_ payload: Data) {
        self.payload = payload
    }

    func data() -> Data {
        return payload
    }

    func compressed(using algorithm: CompressionAlgorithm?) throws -> Payload {
        let compressor = try CompressorFactory.makeCompressor(algorithm: algorithm)
        return Payload(try compressor.compress(data: payload))
    }
}
