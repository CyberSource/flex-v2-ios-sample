
# Cybersource Flex iOS - SDK  

This SDK allows mobile developers to provide credit card payment functionality within their iOS applications, without having to pass sensitive card data back to their application backend servers.  For more information on including payments in your mobile application see our [InApp Payments Guide](TBD)   
   
## SDK Installation 

### CocoaPods
```
    pod 'flex-api-ios-sdk'  
```  

### Manual Installation

Include the ```flex-api-ios-sdk.framework``` in the application. In Xcode, select the main project file for the target. In the "General" section of the project's properties, scroll down to "Embedded Binaries", press the plus sign (+), and select the framework.

Once included, make sure in “Build Settings” tab, in section “Search Paths”, the path to these frameworks are added correctly. 

## SDK Usage

### Merchant details
Please initialize environment to use and merchant details before creating capture context as below. To learn more on generating merchantKey and merchantSecret refer [Cybersource API Reference](https://developer.cybersource.com/api-reference-assets/index.html#authenticationSection)
```
    //use .sandbox to connect to sandbox
    let environment = Environment.production

    let merchantId = "merchantId"
    let merchantKey = "key"
    let merchantSecret = "secret"
```

### Create capture context
Please refer sample application which demonstrates creation of Capture context  
[Sample App](https://github.com/CyberSource/flex-v2-ios-sample) 

```swift
        let captureContext = createCaptureContext()
```
Create capture context uses HTTP Signature Authentication, please refer sample application to know how to create  HTTP Signature and digest. For more information refer [HTTP Signature Authentication](https://developer.cybersource.com/api/developer-guides/dita-gettingstarted/authentication/GenerateHeader/httpSignatureAuthentication.html)

### Initialize the SDK and create transient token using capture context
```swift
        let service = FlexService()
        
        service.createTransientToken(from: captureContext, data: getPayload()) { (result) in
            DispatchQueue.main.async { [weak self] in                
                switch result {
                case .success:
                    //handle success case
                case let .failure(error):
                    //handle error case
                }
            }
        }
```
### Create payload
```swift
        private func getPayload() -> [String: String] {
            var payload = [String: String]()
            payload["paymentInformation.card.number"] = "4111111111111111"
            payload["paymentInformation.card.securityCode"] = "123"
            payload["paymentInformation.card.expirationMonth"] = 12
            payload["paymentInformation.card.expirationYear"] = 29
            return payload
        }
```
### Using the Accept Payment Token to Create a Transaction Request
Your server constructs a transaction request using the [Cybersource API](https://developer.cybersource.com/api-reference-assets/index.html#payments_payments_process-a-payment_samplerequests-dropdown_payment-with-flex-token), placing the encrypted payment information that it received in previous step in the opaqueData element.
```json
{
  "clientReferenceInformation": {
    "code": "TC50171_3"
  },
  "orderInformation": {
    "amountDetails": {
      "totalAmount": "102.21",
      "currency": "USD"
    }
  },
  "tokenInformation": {
    "transientTokenJwt": "eyJraWQiOiIwN0JwSE9abkhJM3c3UVAycmhNZkhuWE9XQlhwa1ZHTiIsImFsZyI6IlJTMjU2In0.eyJkYXRhIjp7ImV4cGlyYXRpb25ZZWFyIjoiMjAyMCIsIm51bWJlciI6IjQxMTExMVhYWFhYWDExMTEiLCJleHBpcmF0aW9uTW9udGgiOiIxMCIsInR5cGUiOiIwMDEifSwiaXNzIjoiRmxleC8wNyIsImV4cCI6MTU5MTc0NjAyNCwidHlwZSI6Im1mLTAuMTEuMCIsImlhdCI6MTU5MTc0NTEyNCwianRpIjoiMUMzWjdUTkpaVjI4OVM5MTdQM0JHSFM1T0ZQNFNBRERCUUtKMFFKMzMzOEhRR0MwWTg0QjVFRTAxREU4NEZDQiJ9.cfwzUMJf115K2T9-wE_A_k2jZptXlovls8-fKY0muO8YzGatE5fu9r6aC4q7n0YOvEU6G7XdH4ASG32mWnYu-kKlqN4IY_cquRJeUvV89ZPZ5WTttyrgVH17LSTE2EvwMawKNYnjh0lJwqYJ51cLnJiVlyqTdEAv3DJ3vInXP1YeQjLX5_vF-OWEuZfJxahHfUdsjeGhGaaOGVMUZJSkzpTu9zDLTvpb1px3WGGPu8FcHoxrcCGGpcKk456AZgYMBSHNjr-pPkRr3Dnd7XgNF6shfzIPbcXeWDYPTpS4PNY8ZsWKx8nFQIeROMWCSxIZOmu3Wt71KN9iK6DfOPro7w"
  }
}
```
## Sample Application
We have a sample application which demonstrates the SDK usage:  
[Sample App](https://github.com/CyberSource/flex-v2-ios-sample) 
