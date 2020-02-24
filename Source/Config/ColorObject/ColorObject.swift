//
//  ColorObject.swift
//  Cotter
//
//  Created by Raymond Andrie on 2/23/20.
//

import Foundation

// Superclass of all color objects
public class ColorObject: NSObject {
    // non constant hex color, allowing change of text
    var hexColor: [String: String]
    
    init(hexColor: [String: String]) {
        self.hexColor = hexColor
    }
    
    public func set(key:String, value:String) {
        print("setting \(key) to \(value)")
        self.hexColor[key] = value
    }
}

// UIColor Extension for Hex/UIColor Conversions
// Taken and Edited from: https://github.com/instamobile/swift-tutorials/blob/master/UIColor%2BHex.swift
extension UIColor {
    convenience init(hexString: String, alpha: CGFloat = 1.0) {
        let hexString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        } else {
            print("Invalid Hex Color!")
            self.init(red: 0, green: 0, blue: 0, alpha: 1.0)
            return
        }
        
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        return String(format:"#%06x", rgb)
    }
}
