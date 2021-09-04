//
//  FlexServiceEndToEndTest.swift
//  flex-api-ios-sdkTests
//
//  Created by Rakesh Ramamurthy on 15/04/21.
//

import XCTest
@testable import flex_api_ios_sdk

class FlexServiceEndToEndTest: XCTestCase {
    
    let cc = "eyJraWQiOiJqNCIsImFsZyI6IlJTMjU2In0.eyJmbHgiOnsicGF0aCI6Ii9mbGV4L3YyL3Rva2VucyIsImRhdGEiOiJ5RTgvN2x2eWROdndFUEdOazc4S2hoQUFFTEYxM3NZV25HUnNWcHFNT1dIMHUxbC93OUl2ZmgvOEJxR3Z0OERmVEY1RURWN1F4dVRKeVhBcHVLVW9IRDdUVTFXM3dNV2Fva1JSb3B6ZEdjNXdOalFcdTAwM2QiLCJvcmlnaW4iOiJodHRwczovL3N0YWdlZmxleC5jeWJlcnNvdXJjZS5jb20iLCJqd2siOnsia3R5IjoiUlNBIiwiZSI6IkFRQUIiLCJ1c2UiOiJlbmMiLCJuIjoieWMwWlhKYlZ1SFdaV0loSXBTMGQ0VXhFQXFLSm9saTRnX2tKRjQxNkthWUVBVjVCWFI2bG8wal9tdWxERzFfYkIyTkcyNGt0WXU5TDJHUHpPZ2owTjNIUVQ1dTdpcEhSRG42bEFkYWUzNnRSaEQ0UUR5OGRoUTM3R0tjWm9jcEtDdXJncEpZSkU5NFVKZmtUWUx2OWlEV3dFTVJ6dU5KbUtxcnp4UTlpdVROUXM5WDFQR2h5UmQ1Sl9PSFdaRzBRMjFia2UtVlhQZDJhNjV6b3haR3BjY1UwSVpLMjg1LTFMM2xoNVNOVGFzc3pZZDQyYXNVbnh4NjhmcWV0WXZHRGZFZUxaeV9WX1lUX21fakJPR05ZbjNsc3hZX0dSb0xKamtZdkR4REdaeGNLRGNvOXk2SDRjb2M1bGZOemZoOElFQklNajAwUC1NeUg4OG41d1VvM2F3Iiwia2lkIjoiMDBuTWZwYlA5NjdKODVBTFpEWFNPNm1kc1ljRDNab0cifX0sImN0eCI6W3siZGF0YSI6eyJyZXF1aXJlZEZpZWxkcyI6WyJwYXltZW50SW5mb3JtYXRpb24uY2FyZC5leHBpcmF0aW9uWWVhciIsInBheW1lbnRJbmZvcm1hdGlvbi5jYXJkLm51bWJlciIsInBheW1lbnRJbmZvcm1hdGlvbi5jYXJkLmV4cGlyYXRpb25Nb250aCIsInBheW1lbnRJbmZvcm1hdGlvbi5jYXJkLnNlY3VyaXR5Q29kZSJdLCJvcHRpb25hbEZpZWxkcyI6WyJwYXltZW50SW5mb3JtYXRpb24uY2FyZC50eXBlIl19LCJ0eXBlIjoiYXBpLTAuMS4wIn1dLCJpc3MiOiJGbGV4IEFQSSIsImV4cCI6MTYxODIwNjM3OSwiaWF0IjoxNjE4MjA1NDc5LCJqdGkiOiJhMWRPblZ3ZEZKUUNJOGU0In0.LYxBbmW6ka30dLVo4XiaI9WgjbcvqTBoTEcUuDz1vASF8x8LBSpR1uRzvd5rOxD2Nd9ASFW-4oySvOeq6vK8xKnAzieLhmvoMunyLSdOAVDXtArU9oO3fbUZMQKCHQp87XzC4oYSu6WdhG8ZpjCDam0wh97dBU-znhxUoaz7xaCSC-cPrBQn0BzIgkhK8WsPe1gWQ6O3UZPCuJzsKXxWtfxhEED32gYZGUtQ1ii2H2mYkMoLdDwunkNryHbMY4ETLTPMOlnKoFwuLidzGBHaU4BbxmbbmE88kyD_P-JHFt9nGthhcqzVgAnMfvDMyjYnpCpZ_W8RwQ9Pb1lwBVVG7A"
    
    func testTransientToken() {
        let service = FlexService()
        
        service.createTransientToken(from: cc, data: getPayloadData()) { (result) in
            switch result {
            case .success:
                print("success")
            case .failure:
                print("failed")
            }
        }
    }
    
    private func getPayloadData() -> [String: Any] {
        let sad = ["paymentInformation.card.number": "1234567891234567",
                    "paymentInformation.card.securityCode": "123",
                    "paymentInformation.card.expirationMonth": "12",
                    "paymentInformation.card.expirationYear": "23"
                ]
        
        return sad
    }
}
        
