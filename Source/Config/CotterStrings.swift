//
//  CotterStrings.swift
//  CotterIOS
//
//  Created by Albert Purnama on 2/6/20.
//

import UIKit

// CotterStrings is the list of constant strings that will be used for the keys
// on the Strings' class variable mapping
public class CotterStrings: NSObject {
    public static let showPIN = "showPin"
    public static let hidePIN = "hidePin"
    public static let closeMessage = "closeMessage"
    public static let closeTitle = "closeTitle"
    public static let stayText = "stayText"
    public static let leaveText = "leaveText"
}

let defaultText = [
    CotterStrings.showPIN: "Lihat PIN",
    CotterStrings.hidePIN: "Sembunyikan",
    CotterStrings.closeTitle: "Yakin tidak Mau Buat PIN Sekarang?",
    CotterStrings.closeMessage: "PIN Ini diperlukan untuk keamanan akunmu, lho.",
    CotterStrings.stayText: "Input PIN",
    CotterStrings.leaveText: "Lain Kali"
]

// Strings will be used inside the classes
class Strings: NSObject {
    private static var pinView = [String: String]()
    private static var pinConfirmationView = [String: String]()
    
    // MARK - setter and getters

    public static func setPinView(key: String, val: String) {
        pinView[key] = val
    }
    
    public static func getPinView(key: String) -> String {
        let val = pinView[key]
        if val != nil {
            return val!
        }
        return ""
    }
    
    public static func setPinConfirmationView(key: String, val: String) {
        pinConfirmationView[key] = val
    }
    
    public static func getPinConfirmationView(key: String) -> String {
        let val = pinConfirmationView[key]
        if val != nil {
            return val!
        }
        return ""
    }
}
