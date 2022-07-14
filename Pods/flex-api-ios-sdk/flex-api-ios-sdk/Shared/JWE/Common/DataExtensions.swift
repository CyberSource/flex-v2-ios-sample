//
//  DataExtensions.swift
//  flex_api_ios_sdk
//
//  Created by Rakesh Ramamurthy on 19/04/21.
//

import Foundation

extension Data {

    func base64URLEncodedString() -> String {
        let s = self.base64EncodedString()
        return s
            .replacingOccurrences(of: "=", with: "")
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
    }

    func base64URLEncodedData() -> Data {
        return self.base64URLEncodedString().data(using: .utf8)!
    }

    func getByteLengthAsOctetHexData() -> Data {
        let dataLength = UInt64(self.count * 8)
        let dataLengthInHex = String(dataLength, radix: 16, uppercase: false)

        var dataLengthBytes = [UInt8](repeatElement(0x00, count: 8))

        var dataIndex = dataLengthBytes.count-1
        for index in stride(from: 0, to: dataLengthInHex.count, by: 2) {
            var offset = 2
            var hexStringChunk = ""

            if dataLengthInHex.count-index == 1 {
                offset = 1
            }

            let endIndex = dataLengthInHex.index(dataLengthInHex.endIndex, offsetBy: -index)
            let startIndex = dataLengthInHex.index(endIndex, offsetBy: -offset)
            let range = Range(uncheckedBounds: (lower: startIndex, upper: endIndex))
            hexStringChunk = String(dataLengthInHex[range])

            if let hexByte = UInt8(hexStringChunk, radix: 16) {
                dataLengthBytes[dataIndex] = hexByte
            }

            dataIndex -= 1
        }

        return Data(dataLengthBytes)
    }
}

extension Data: DataConvertible {
    init(_ data: Data) {
        self = data
    }

    func data() -> Data {
        return self
    }
}
