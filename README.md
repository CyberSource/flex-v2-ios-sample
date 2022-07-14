
# Cybersource Flex iOS - SampleApp  

  
  This SDK allows mobile developers to provide credit card payment functionality within their iOS applications, without having to pass sensitive card data back to their application backend servers.  For more information on including payments in your mobile application see our [InApp Payments Guide](https://developer.cybersource.com/)   
     
  ## SDK Installation 

    ### CocoaPods
    CocoaPods is a dependency manager for Cocoa projects. For usage and installation instructions, visit their website. To integrate Cybersource Flex iOS SDK into your Xcode project using CocoaPods, specify it in your Podfile:
    
  ```swift
        pod 'flex-api-ios-sdk'
  ```

  ### Configure merchant details
  ```swift
    val merchantId = "<MerchantID>"
    val merchantSecret = "<MerchantSecret>"
    val merchantKey = "<MerchantKey>"
 ```

  ### How to run the sample application?

  Select  ```flex-client-sdk``` from target list. Keep only ```flex-client-sdk``` and ```CybersourceFlexSDK```,  remove any other schemes from Manage Schemes option.

  Once selected, run the application. 

  ## SDK Usage

  ### Configure merchant details

  ### Create capture context
  Please refer sample application which demonstrates creation of Capture context  
  [Sample App](https://github.com/CyberSource/flex-v2-ios-sample) 

  ```swift
          let captureContext = createCaptureContext()
  ```

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
  Your server constructs a transaction request using the [Cybersource API](https://developer.cybersource.com/), placing the encrypted payment information that it received in previous step in the opaqueData element.
  ```json
     {
      "createTransactionRequest": {
          "merchantAuthentication": {
              "name": "YOUR_API_LOGIN_ID",
              "transactionKey": "YOUR_TRANSACTION_KEY"
          },
          "refId": "123456",
          "transactionRequest": {
              "transactionType": "authCaptureTransaction",
              "amount": "5",
              "payment": {
                  "opaqueData": {
                      "dataDescriptor": "COMMON.ACCEPT.INAPP.PAYMENT",
                      "dataValue": "PAYMENT_NONCE_GOES_HERE"
                  }
              }
          }
      }
  }
  ```
  ## Sample Application
  We have a sample application which demonstrates the SDK usage:  
     [Sample App](https://github.com/CyberSource/flex-v2-ios-sample)
    
  ## Important note:
  The generation of the capture context should originate from your payment application server.  As this is a fully authenticated REST api it requires your API credentials which are not secured on a mobile application.  It has been included in this demonstration for the purpose of convenience and to demonstrate an end-to-end payment flow.

