//
//  ViewController.swift
//  flex-api-ios-sample-app
//
//  Created by Rakesh Ramamurthy on 17/03/21.
//

import UIKit
import flex_api_ios_sdk

let kFlexSDKDemoCreditCardLength:Int = 16
let kFlexSDKDemoCreditCardLengthPlusSpaces:Int = (kFlexSDKDemoCreditCardLength + 3)
let kFlexSDKDemoExpirationLength:Int = 4
let kFlexSDKDemoExpirationMonthLength:Int = 2
let kFlexSDKDemoExpirationYearLength:Int = 2
let kFlexSDKDemoExpirationLengthPlusSlash:Int = kFlexSDKDemoExpirationLength + 1
let kFlexSDKDemoCVV2Length:Int = 4

let kFlexSDKDemoCreditCardObscureLength:Int = (kFlexSDKDemoCreditCardLength - 4)

let kFlexSDKDemoSpace:String = " "
let kFlexSDKDemoSlash:String = "/"

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var cardNumberTextField:UITextField!
    @IBOutlet weak var expirationMonthTextField:UITextField!
    @IBOutlet weak var expirationYearTextField:UITextField!
    @IBOutlet weak var cardVerificationCodeTextField:UITextField!
    @IBOutlet weak var getTokenButton:UIButton!
    @IBOutlet weak var activityIndicatorAcceptSDKDemo:UIActivityIndicatorView!
    @IBOutlet weak var errorDescriptionLabel:UILabel!
    @IBOutlet weak var errorContainerView:UIView!

    fileprivate var cardNumber:String!
    fileprivate var cardExpirationMonth:String!
    fileprivate var cardExpirationYear:String!
    fileprivate var cardVerificationCode:String!
    fileprivate var cardNumberBuffer:String!
    fileprivate var captureContextResponseString: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUIControlsTagValues()
        self.initializeUIControls()
        self.initializeMembers()
        self.updateTokenButton(false)
    }

    func setUIControlsTagValues() {
        self.cardNumberTextField.tag = 1
        self.expirationMonthTextField.tag = 2
        self.expirationYearTextField.tag = 3
        self.cardVerificationCodeTextField.tag = 4
    }
    
    func initializeUIControls() {
        showActivityIndicator(show: false)
        self.cardNumberTextField.text = ""
        self.expirationMonthTextField.text = ""
        self.expirationYearTextField.text = ""
        self.cardVerificationCodeTextField.text = ""
        self.textChangeDelegate(self.cardNumberTextField)
        self.textChangeDelegate(self.expirationMonthTextField)
        self.textChangeDelegate(self.expirationYearTextField)
        self.textChangeDelegate(self.cardVerificationCodeTextField)
        
        self.cardNumberTextField.delegate = self
        self.expirationMonthTextField.delegate = self
        self.expirationYearTextField.delegate = self
        self.cardVerificationCodeTextField.delegate = self
    }
    
    @IBAction func hideKeyBoard(_ sender: AnyObject) {
        self.view.endEditing(true)
    }
    
    @IBAction func tokenize() {
        if let yearStr = self.expirationYearTextField.text,
           yearStr.count > 0 {
            validateYear(yearStr)
        }
        
        requestCaptureContext()
    }

    func initializeMembers() {
        self.cardNumber = nil
        self.cardExpirationMonth = nil
        self.cardExpirationYear = nil
        self.cardVerificationCode = nil
        self.cardNumberBuffer = ""
    }

    private func showActivityIndicator(show: Bool) {
        if (show) {
            self.activityIndicatorAcceptSDKDemo.isHidden = false
            self.activityIndicatorAcceptSDKDemo.startAnimating()
        } else {
            self.activityIndicatorAcceptSDKDemo.isHidden = true
            self.activityIndicatorAcceptSDKDemo.stopAnimating()
        }
    }
    
    private func requestCaptureContext() {
        showActivityIndicator(show: true)
        hideError()
        
        /*  WARNING:
            Before creating TransientToken make sure you have a valid capture context.
            And below creation of capture context code is for demonstration purpose only.
        */
        CaptureContext().createCaptureContext() { [weak self] (result) in
            DispatchQueue.main.async {
                self?.showActivityIndicator(show: false)
                switch(result) {
                case let .success(response):
                    if let sessionToken = response.keyId {
                        self?.captureContextResponseString = sessionToken
                        self?.createTransientToken()
                    }
                    break
                case let .failure(error):
                    self?.showSessionCreationError(error: error)
                }
            }
        }
    }
                
    private func createTransientToken() {
        showActivityIndicator(show: true)
        hideError()

        /*
            This is the place where we use FlexService->createTransientToken() method to generate the TransientToken.
            Input for createTokenAsyncTask() method will be capture context(captureContextResponseString) string and the event listeners. Note createTransientToken() is an asynchronous method.
        */

        let service = FlexService()
        
        service.createTransientToken(from: self.captureContextResponseString, data: getPayload()) { (result) in
            DispatchQueue.main.async { [weak self] in
                self?.showActivityIndicator(show: false)
                
                switch result {
                case .success:
                    self?.showResponseController()
                case let .failure(error):
                    self?.showTokenCreationError(error: error)
                }
            }
        }
    }
    
    /*
        Payload is must for creating transient token. The sample payload creation in this SampleApp is
        only for demonstration purpose, this should be changed according to your use cases.
    */
    private func getPayload() -> [String: String] {
        var payload = [String: String]()
        if let cardNumber = self.cardNumber {
            payload["paymentInformation.card.number"] = cardNumber
        }
        
        if let cvv = self.cardVerificationCode {
            payload["paymentInformation.card.securityCode"] = cvv
        }
        
        if let expMonth = self.cardExpirationMonth {
            payload["paymentInformation.card.expirationMonth"] = expMonth
        }
        
        if let expYear = self.cardExpirationYear {
            payload["paymentInformation.card.expirationYear"] = expYear
        }

        return payload
    }
    
    private func showSessionCreationError(error: Error) {
        self.errorContainerView.isHidden = false
        self.errorDescriptionLabel.text = error.localizedDescription
    }
    
    private func hideError() {
        self.errorContainerView.isHidden = true
    }

    private func showTokenCreationError(error: FlexErrorResponse) {
        self.errorContainerView.isHidden = false
        self.errorDescriptionLabel.text = error.responseStatus.message
    }
    
    func formatCardNumber(_ textField:UITextField) {
        var value = String()
        
        if textField == self.cardNumberTextField {
            let length = self.cardNumberBuffer.count
            
            for (i, _) in self.cardNumberBuffer.enumerated() {

                // Reveal only the last character.
                if (length <= kFlexSDKDemoCreditCardObscureLength) {
                    if (i == (length - 1)) {
                        let charIndex = self.cardNumberBuffer.index(self.cardNumberBuffer.startIndex, offsetBy: i)
                        let tempStr = String(self.cardNumberBuffer.suffix(from: charIndex))
                        //let singleCharacter = String(tempStr.characters.first)

                        value = value + tempStr
                    } else {
                        value = value + "●"
                    }
                } else {
                    if (i < kFlexSDKDemoCreditCardObscureLength) {
                        value = value + "●"
                    } else {
                        let charIndex = self.cardNumberBuffer.index(self.cardNumberBuffer.startIndex, offsetBy: i)
                        let tempStr = String(self.cardNumberBuffer.suffix(from: charIndex))
                        //let singleCharacter = String(tempStr.characters.first)
                        //let singleCharacter = String(tempStr.characters.suffix(1))
                        
                        value = value + tempStr
                        break
                    }
                }
                
                //After 4 characters add a space
                if (((i + 1) % 4 == 0) && (value.count < kFlexSDKDemoCreditCardLengthPlusSpaces)) {
                    value = value + kFlexSDKDemoSpace
                }
            }
        }
        
        textField.text = value
    }

    func isMaxLength(_ textField:UITextField) -> Bool {
        var result = false
        
        if (textField.tag == self.cardNumberTextField.tag && textField.text!.count > kFlexSDKDemoCreditCardLengthPlusSpaces)
        {
            result = true
        }
        
        if (textField == self.expirationMonthTextField && textField.text!.count > kFlexSDKDemoExpirationMonthLength)
        {
            result = true
        }
        
        if (textField == self.expirationYearTextField && textField.text!.count > kFlexSDKDemoExpirationYearLength)
        {
            result = true
        }
        if (textField == self.cardVerificationCodeTextField && textField.text!.count > kFlexSDKDemoCVV2Length)
        {
            result = true
        }
        
        return result
    }
    
    
    // MARK:
    // MARK: UITextViewDelegate delegate methods
    // MARK:
    
    func textFieldDidBeginEditing(_ textField:UITextField) {
        if (self.validInputs())
        {
            self.updateTokenButton(true)
        }
        else
        {
            self.updateTokenButton(false)
        }
    }
    
    func textFieldShouldBeginEditing(_ textField:UITextField) -> Bool {
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let result = true
        
        switch (textField.tag)
        {
        case 1:
                if (string.count > 0)
                {
                    if (self.isMaxLength(textField)) {
                        return false
                    }
                    
                    self.cardNumberBuffer = String(format: "%@%@", self.cardNumberBuffer, string)
                }
                else
                {
                    if (self.cardNumberBuffer.count > 1)
                    {
                        let length = self.cardNumberBuffer.count - 1
                        
            //self.cardNumberBuffer = self.cardNumberBuffer[self.cardNumberBuffer.index(self.cardNumberBuffer.startIndex, offsetBy: 0)...self.cardNumberBuffer.index(self.cardNumberBuffer.startIndex, offsetBy: length-1)]
                        
                        self.cardNumberBuffer = String(self.cardNumberBuffer[self.cardNumberBuffer.index(self.cardNumberBuffer.startIndex, offsetBy: 0)...self.cardNumberBuffer.index(self.cardNumberBuffer.startIndex, offsetBy: length - 1)])
                    }
                    else
                    {
                        self.cardNumberBuffer = ""
                    }
                }
                self.formatCardNumber(textField)
                return false
        case 2:

            if (string.count > 0) {
                if (self.isMaxLength(textField)) {
                    return false
                }
            }

            break
        case 3:

            if (string.count > 0) {
                if (self.isMaxLength(textField)) {
                    return false
                }
            }

            break
        case 4:

            if (string.count > 0) {
                if (self.isMaxLength(textField)) {
                    return false
                }
            }

            break
            
        default:
            break
        }
        
        return result
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        let validator = FlexSDKCardFieldsValidator()

        switch (textField.tag)
        {
            
        case 1:

            self.cardNumber = self.cardNumberBuffer
                
                let luhnResult = validator.validateCardWithLuhnAlgorithm(self.cardNumberBuffer)
                
            if ((luhnResult == false) || (textField.text!.count < FlexSDKCardFieldsValidatorConstants.kFlexSDKCardNumberCharacterCountMin))
                {
                    self.cardNumberTextField.textColor = UIColor.red
                }
                else
                {
                    self.cardNumberTextField.textColor = self.darkBlueColor() //[UIColor greenColor]
                }
                
                if (self.validInputs())
                {
                    self.updateTokenButton(true)
                }
                else
                {
                    self.updateTokenButton(false)
                }

            break
        case 2:
            self.validateMonth(textField)

            break
        case 3:
            
            self.validateYear(textField.text!)

            break
        case 4:

            self.cardVerificationCode = textField.text
                
                if (validator.validateSecurityCodeWithString(self.cardVerificationCodeTextField.text!))
                {
                    self.cardVerificationCodeTextField.textColor = self.darkBlueColor()
                }
                else
                {
                    self.cardVerificationCodeTextField.textColor = UIColor.red
                }
                
                if (self.validInputs())
                {
                    self.updateTokenButton(true)
                }
                else
                {
                    self.updateTokenButton(false)
                }

            break
            
        default:
            break
        }
    }

    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        if (textField == self.cardNumberTextField)
        {
            self.cardNumberBuffer = String()
        }
        
        return true
    }
    
    func validateYear(_ textFieldText: String) {
        
        self.cardExpirationYear = textFieldText
        let validator = FlexSDKCardFieldsValidator()

        let newYear = Int(textFieldText)
        if ((newYear! >= validator.cardExpirationYearMin())  && (newYear! <= FlexSDKCardFieldsValidatorConstants.kFlexSDKCardExpirationYearMax))
        {
            self.expirationYearTextField.textColor = self.darkBlueColor() //[UIColor greenColor]
        }
        else
        {
            self.expirationYearTextField.textColor = UIColor.red
        }
        
        if (self.expirationYearTextField.text?.count == 0)
        {
            return
        }
        if (self.expirationMonthTextField.text?.count == 0)
        {
            return
        }
        if (validator.validateExpirationDate(self.expirationMonthTextField.text!, inYear: self.expirationYearTextField.text!))
        {
            self.expirationMonthTextField.textColor = self.darkBlueColor()
            self.expirationYearTextField.textColor = self.darkBlueColor()
        }
        else
        {
            self.expirationMonthTextField.textColor = UIColor.red
            self.expirationYearTextField.textColor = UIColor.red
        }
        
        if (self.validInputs())
        {
            self.updateTokenButton(true)
        }
        else
        {
            self.updateTokenButton(false)
        }
    }

    func validInputs() -> Bool {
        var inputsAreOKToProceed = false
        
        let validator = FlexSDKCardFieldsValidator()
        
        if (validator.validateSecurityCodeWithString(self.cardVerificationCodeTextField.text!) && validator.validateExpirationDate(self.expirationMonthTextField.text!, inYear: self.expirationYearTextField.text!) && validator.validateCardWithLuhnAlgorithm(self.cardNumberBuffer)) {
            inputsAreOKToProceed = true
        }

        return inputsAreOKToProceed
    }

    func updateTokenButton(_ isEnable: Bool) {
        self.getTokenButton.isEnabled = isEnable
        if isEnable {
            self.getTokenButton.backgroundColor = UIColor.init(red: 48.0/255.0, green: 85.0/255.0, blue: 112.0/255.0, alpha: 1.0)
        } else {
            self.getTokenButton.backgroundColor = UIColor.init(red: 48.0/255.0, green: 85.0/255.0, blue: 112.0/255.0, alpha: 0.2)
        }
    }

    func validateMonth(_ textField: UITextField) {
        
        self.cardExpirationMonth = textField.text
        
        if (self.expirationMonthTextField.text?.count == 1)
        {
            if ((textField.text == "0") == false) {
                self.expirationMonthTextField.text = "0" + self.expirationMonthTextField.text!
            }
        }
        
        let newMonth = Int(textField.text!)
        
        if ((newMonth! >= FlexSDKCardFieldsValidatorConstants.kFlexSDKCardExpirationMonthMin)  && (newMonth! <= FlexSDKCardFieldsValidatorConstants.kFlexSDKCardExpirationMonthMax))
        {
            self.expirationMonthTextField.textColor = self.darkBlueColor() //[UIColor greenColor]
            
        }
        else
        {
            self.expirationMonthTextField.textColor = UIColor.red
        }
        
        if (self.validInputs())
        {
            self.updateTokenButton(true)
        }
        else
        {
            self.updateTokenButton(false)
        }
    }

    func darkBlueColor() -> UIColor {
        let color = UIColor.init(red: 51.0/255.0, green: 102.0/255.0, blue: 153.0/255.0, alpha: 1.0)
        return color
    }

    func textChangeDelegate(_ textField: UITextField) {
        NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: textField, queue: nil, using: { note in
                if (self.validInputs()) {
                    self.updateTokenButton(true)
                } else {
                    self.updateTokenButton(false)
                }
            })
    }
    
    private func showResponseController() {
        self.performSegue(withIdentifier: "showResponseSegueId", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is TokenResponseViewController {
            let vc = segue.destination as? TokenResponseViewController
            vc?.responseString = self.captureContextResponseString
        }
    }
    
    @IBAction func linkBtnClicked() {
        if let url = URL(string: "https://developer.cybersource.com/") {
            UIApplication.shared.open(url)
        }
    }
}


