//
//  FlexSDKCardFieldsValidator.swift
//  flex-api-ios-sample-app
//
//  Created by Rakesh Ramamurthy on 17/03/21.
//

import Foundation
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func >= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l >= r
  default:
    return !(lhs < rhs)
  }
}

fileprivate func <= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l <= r
  default:
    return !(rhs < lhs)
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


struct FlexSDKCardFieldsValidatorConstants {
    static let kFlexSDKCardNumberCharacterCountMin:Int = 12
    static let kFlexSDKCardNumberCharacterCountMax:Int = 19
    static let kFlexSDKCardExpirationMonthMin:Int = 1
    static let kFlexSDKCardExpirationMonthMax:Int = 12
    static let kFlexSDKCardExpirationYearMax:Int = 99
    static let kFlexSDKSecurityCodeCharacterCountMin:Int = 3
    static let kFlexSDKSecurityCodeCharacterCountMax:Int = 4
    static let kFlexSDKZipCodeCharacterCountMax:Int = 5
}

class FlexSDKCardFieldsValidator: NSObject {
    
    override init() {
    }
    
    @objc func cardExpirationYearMin() -> Int {
        let gregorian = Calendar(identifier: Calendar.Identifier.gregorian)
        let components = (gregorian as NSCalendar?)?.components(.year, from: Date())
        return (components?.year)! % 100
    }
    
    // Helper method to validate card
    @objc func validateCardNumberWithString(_ inCardNumber: String) -> Bool {
        var result = false
        
        let tempCardNumber = inCardNumber.replacingOccurrences(of: String.space(), with: String())
        
        if FlexSDKStringValidator.isNumber(tempCardNumber) {
            if ((tempCardNumber.count >= FlexSDKCardFieldsValidatorConstants.kFlexSDKCardNumberCharacterCountMin) &&
                tempCardNumber.count <= FlexSDKCardFieldsValidatorConstants.kFlexSDKCardNumberCharacterCountMax) {
                result = true
            }
        }
        return result
    }
    
    // Helper method to validate Month
    @objc func validateMonthWithString(_ inMonth: String) -> Bool {
        var result = false
        
        if FlexSDKStringValidator.isNumber(inMonth) {
            let monthNumber = Int(inMonth)
            
            if ((monthNumber >= FlexSDKCardFieldsValidatorConstants.kFlexSDKCardExpirationMonthMin) &&
                (monthNumber <= FlexSDKCardFieldsValidatorConstants.kFlexSDKCardExpirationMonthMax)) {
                result = true
            }
        }

        return result
    }

    // Helper method to validate Year
    @objc func validateYearWithString(_ inYear: String) -> Bool {
        var result = false
        
        if ((inYear.count != 2) || (inYear.count != 4)) {
            result = false
        }
        
        if inYear.count == 2 {
            if FlexSDKStringValidator.isNumber(inYear) {
                let yearNumber = Int(inYear)
                
                if ((yearNumber >= self.cardExpirationYearMin()%100) &&
                    (yearNumber <= FlexSDKCardFieldsValidatorConstants.kFlexSDKCardExpirationYearMax)) {
                    result = true
                }
            }
        } else if inYear.count == 4 {
            if FlexSDKStringValidator.isNumber(inYear) {
                let yearNumber = Int(inYear)
                
                if yearNumber >= self.cardExpirationYearMin() {
                    result = true
                }
            }
        } else {
            result = false
        }
        
        return result
    }

    // Helper method to validate security code
    @objc func validateSecurityCodeWithString(_ inSecurityCode: String) -> Bool {
        var result = false
        
        if FlexSDKStringValidator.isNumber(inSecurityCode) {
            if ((inSecurityCode.count == FlexSDKCardFieldsValidatorConstants.kFlexSDKSecurityCodeCharacterCountMin) ||
                (inSecurityCode.count == FlexSDKCardFieldsValidatorConstants.kFlexSDKSecurityCodeCharacterCountMax)) {
                result = true
            }
        }

        return result
    }
    
    // Helper method to validate zipcode
    @objc func validateZipCodeWithString(_ inZipCode: String) -> Bool {
        var result = false
        
        if FlexSDKStringValidator.isNumber(inZipCode) {
            if (inZipCode.count == FlexSDKCardFieldsValidatorConstants.kFlexSDKZipCodeCharacterCountMax) {
                result = true
            }
        }
        
        return result
    }
    
    //!--------------------------------------------- advance validation -----------------------------------
    
    @objc func validateCardWithLuhnAlgorithm(_ inCardNumber: String) -> Bool {
        var result = false
        
        let tempCardNumber = inCardNumber.replacingOccurrences(of: String.space(), with: String())
        
        if inCardNumber.count > 0 {
            let elementsCount = tempCardNumber.count
            var arrayOfIntegers = [Int?](repeating: nil, count: elementsCount)

            for (index, _) in tempCardNumber.enumerated() {
                let charIndex = tempCardNumber.index(tempCardNumber.startIndex, offsetBy: index)
                let tempStr = String(tempCardNumber.suffix(from: charIndex))
                let singleCharacter = String(tempStr.prefix(1))//String(tempStr.characters.first)
                
                arrayOfIntegers[tempCardNumber.count - 1 - index] = Int(singleCharacter)
            }
            
            for (index, _) in tempCardNumber.enumerated() {
                if index%2 != 0 {
                    arrayOfIntegers[index] = arrayOfIntegers[index]! * 2
                }
            }
            
            var theSum = 0
            for (index, _) in tempCardNumber.enumerated() {
                if arrayOfIntegers[index] > 9 {
                    theSum += arrayOfIntegers[index]! / 10
                    theSum += arrayOfIntegers[index]! % 10
                } else {
                    theSum += arrayOfIntegers[index]!
                }
            }
            
            if ((theSum != 0) && ((theSum % 10) == 0)) {
                result = true
            }
        }
        return result
    }

    // Helper method to validate Card Expiration date
    @objc func validateExpirationDate(_ inMonth: String, inYear:String) -> Bool {
        var result = false

        if (self.validateMonthWithString(inMonth) && self.validateYearWithString(inYear)) {
            //---  now date
            let nowDate = Date()
            
            //--- date expiration
            var comps = DateComponents()
            comps.day = 1
            comps.month = Int(inMonth)!
            if inYear.count == 2 {
                comps.year = 2000+Int(inYear)!
            } else if inYear.count == 4 {
                comps.year = Int(inYear)!
            }
            
            let expirationDate = Calendar.current.date(from: comps)
            
            //--- next month after expiration
            var monthComponents = DateComponents()
            monthComponents.month = 1
            
            let nextDayAfterExpirationDate = (Calendar.current as NSCalendar).date(byAdding: monthComponents, to: expirationDate!, options: NSCalendar.Options(rawValue: 0))
            
            let timeIntervalSinceDate = nextDayAfterExpirationDate!.timeIntervalSince(nowDate)
            result = (timeIntervalSinceDate > 0)
        }

        return result
    }
    
    @objc func validateExpirationDate(_ inExpirationDate: String) -> Bool {
        var result = false
        
        let monthRange = inExpirationDate.startIndex..<inExpirationDate.index(inExpirationDate.startIndex, offsetBy: 2)
        let month = inExpirationDate[monthRange]
        
        let yearRange = inExpirationDate.index(inExpirationDate.startIndex, offsetBy: 2)..<inExpirationDate.endIndex
        let year = inExpirationDate[yearRange]

        if self.validateExpirationDate(String(month), inYear: String(year)) {
            result = true
        }
        
        return result
    }
}

extension String {
    
    subscript (i: Int) -> Character {
        return self[self.index(self.startIndex, offsetBy: i)]
    }
    
    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
    
    subscript (r: Range<Int>) -> String {
        let start = index(startIndex, offsetBy: r.lowerBound)
        let end = index(start, offsetBy: r.upperBound - r.lowerBound)
        return String(self[start ..< end])
    }
}
