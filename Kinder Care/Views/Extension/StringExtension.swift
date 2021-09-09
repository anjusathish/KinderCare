//
//  StringExtension.swift
//  Customer
//
//  Created by Athiban Ragunathan on 23/11/17.
//  Copyright © 2017 Athiban Ragunathan. All rights reserved.
//

import UIKit

extension Date {
    
    func getasString(inFormat format:String) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
}

extension String {
    
    struct acceptedPhoneNumber {
        static let startingWith = ["9","8","7"]
        static let countryCode = ["9","1"]
    }
    
    func isValidPhone() -> Bool {
        let PHONE_REGEX = REGEX.phone_aus
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: self)
        return result
    }
    
    func isValidPostalCode() -> Bool {
        let regex = "^[1-9][0-9]{3}\\$"
        let postalTest = NSPredicate(format: "SELF MATCHES %@", regex)
        let result =  postalTest.evaluate(with: self)
        return result
    }
    
    func isValidGlobalPhone() -> Bool {
        
     return  (self.removeWhiteSpace().count >= 8 && self.removeWhiteSpace().count <= 13)
    }
  
    func isValidEmail() -> Bool {
        let emailRegEx = REGEX.email
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    func isIndianPhoneNumber() -> Bool {
        
        switch self.count {
        case 10:
            
            if acceptedPhoneNumber.startingWith.contains(self[0]) {
                return true
            }
            
        case 11 :
            
            if self[0] == "0" {
                
                var stringToTrimm = self
                
                stringToTrimm.remove(at: stringToTrimm.startIndex)
                
                if acceptedPhoneNumber.startingWith.contains((stringToTrimm[0])) {
                    return true
                }
            }
            
        case 12 :
            
            if acceptedPhoneNumber.countryCode[0] == self[0] && acceptedPhoneNumber.countryCode[1] == self[1] {
                return true
            }
            
        default:break
            
        }
        return false
    }
    
    func formattedPhoneNo() -> String {
        
        switch self.count {
        case 10:
            
            if acceptedPhoneNumber.startingWith.contains(self[0]) {
                return "+91" + self
            }
            
        case 11 :
            
            if self[0] == "0" {
                
                var stringToTrimm = self
                
                stringToTrimm.remove(at: stringToTrimm.startIndex)
                
                if acceptedPhoneNumber.startingWith.contains((stringToTrimm[0])) {
                    return "+91" + stringToTrimm
                }
            }
            
        case 12 :
            
            if acceptedPhoneNumber.countryCode[0] == self[0] && acceptedPhoneNumber.countryCode[1] == self[1] {
                return "+" + self
            }
            
            
        default:break
            
        }
        return self
    }
    
    func urlEncoded() -> String {
        return self.replacingOccurrences(of: "+", with: "%2B")
    }
    
    func emojiString() -> String {
        if let data = self.data(using: .utf8) {
            if let string =  String.init(data: data, encoding: .nonLossyASCII) {
                return string
            }
            else {
                return self
            }
        }
        else {
            return self
        }
    }
    
    func postEmojiString() -> String {
        
        if let data = self.data(using: .nonLossyASCII) {
            if let string =  String.init(data: data, encoding: .utf8) {
                return string
            }
            else {
                return self
            }
        }
        else {
            return self
        }
    }
    
    func addCurrencyFormat() -> String {
        
        guard let value = Int(self) else {
            return ""
        }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale.current
        formatter.maximumFractionDigits = 0;
        
        return formatter.string(from: NSNumber(value: value)) ?? ""
    }
    
    func removeWhiteSpace() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func removeNewLines() -> String {
        return self.replacingOccurrences(of: "\n", with: ",")
    }
    
    func getDateAsStringWith(inFormat : String, outFormat : String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = inFormat
        
        if let date = dateFormatter.date(from: self) {
            dateFormatter.dateFormat = outFormat
            return dateFormatter.string(from: date)
        }
        else {
            return self
        }
    }
    
    func getDate(inFormat : String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = inFormat
        
        if let date = dateFormatter.date(from: self) {
            return date
        }
        else {
            return Date()
        }
    }
    
    subscript (i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }
    
    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
    
    func mandatoryAttributedString() -> NSMutableAttributedString {
        
        let attributedString = NSMutableAttributedString(string: self)
        let asterix = NSAttributedString(string: "*", attributes: [.foregroundColor: UIColor.red])
        let mutableText = NSMutableAttributedString(attributedString: attributedString)
        mutableText.append(asterix)
        return mutableText as NSMutableAttributedString
        
    }
    
    func formatErrorMessage() -> NSAttributedString {
        
         let attrs = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: UIFont.TextStyle.headline)]
        
         return NSAttributedString(string: self.replacingOccurrences(of: "message(", with: "").replacingOccurrences(of: ")", with: "").replacingOccurrences(of: "\"", with: ""), attributes: attrs)
    }
}


extension Date {
    
    var ticks: UInt64 {
        return UInt64((self.timeIntervalSince1970 + 62_135_596_800) * 10)
    }
    
    func asString(withFormat format : String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.calendar = NSCalendar.current
         dateFormatter.timeZone = TimeZone.current
        return dateFormatter.string(from: self)
    }
}
