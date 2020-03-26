//
//  String.swift
//  Cotter
//
//  Created by Raymond Andrie on 3/26/20.
//

import Foundation

extension String {
    func maskContactInfo(method: String) -> String {
        switch method {
        case CotterConstants.MethodPhone:
            return maskPhoneNumber(number: self)
        case CotterConstants.MethodEmail:
            return maskEmail(email: self)
        default:
            return self // unmasked
        }
    }
    
    func maskPhoneNumber(number: String) -> String {
        let numberArr = number.enumerated()
        let len = number.count
        let hiddenPhoneNumArr = numberArr.map { index, char in
            return [0, 1, len-4, len-3, len-2, len-1].contains(index) ? char : "*"
        }
        return String(hiddenPhoneNumArr)
    }
    
    func maskEmail(email: String) -> String {
        let components = email.components(separatedBy: "@")
        return "\(hideMidChars(components.first!))@\(components.last!)"
    }
    
    // Inspired from
    // https://stackoverflow.com/questions/49221693/masking-email-and-phone-number-in-swift-4
    func hideMidChars(_ value: String) -> String {
        let valueArr = value.enumerated()
        let len = value.count
        let hiddenMidCharsArr = valueArr.map { index, char in
            return [0, 1, len-2, len-1].contains(index) ? char : "*"
        }
        return String(hiddenMidCharsArr)
    }
}
