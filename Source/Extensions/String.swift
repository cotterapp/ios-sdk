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
        case CotterMethods.Phone:
            return maskPhoneNumber(number: self)
        case CotterMethods.Email:
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
    
    // get the text out inside tag from the sentence with multiple text
    func getChosenTexts(betweenTag tag: String, isRemoveTag: Bool = false) -> [String] {
        let regex = try! NSRegularExpression(pattern:"\(tag)(.*?)\(tag)", options: [])
        var results = [String]()
        
        regex.enumerateMatches(
        in: self,
        options: [],
        range: NSMakeRange(0, self.utf16.count)) { result, flags, stop in
            
            if let r = result?.range(at: 0),
                let range = Range(r, in: self) {
                
                results.append(String(self[range]))
            }
        }
        
        if results.count != 0 {
            if isRemoveTag {
                for index in 0..<results.count {
                    results[index] = results[index].replacingOccurrences(of: tag, with: "")
                }
            }
            return results
        } else {
            return []
        }
        
    }
}

extension UILabel {
    
    // custom styling text between tag
    func setupFontStyleBetweenTag(
        font: UIFont,
        color: UIColor,
        tag: String) {
        
        if let text = text, text.contains(tag) {
            let boldTexts = text.getChosenTexts(betweenTag: tag, isRemoveTag: true)
            let cleanText = text.replacingOccurrences(of: tag, with: "")
            
            let attr = NSMutableAttributedString(string: cleanText)
            for boldText in boldTexts {
                let range = (cleanText as NSString).range(of: boldText)
                attr.addAttributes(
                    [
                        NSAttributedString.Key.font : font,
                        NSAttributedString.Key.foregroundColor: color,
                    ],
                    range: range)
            }
            self.attributedText = attr
        }
    }
    
}
