//
//  UIColor.swift
//  Cotter
//
//  Created by Calvin Tjoeng on 2/21/20.
//

import Foundation

extension UIColor {
    // Code from https://stackoverflow.com/questions/24263007/how-to-use-hex-color-values
    convenience init(red: Int = 0, green: Int = 0, blue: Int = 0, alpha: CGFloat = 1.0) {
        guard
            0x0...0xFF ~= red,
            0x0...0xFF ~= green,
            0x0...0xFF ~= blue,
            0.0...1.0 ~= alpha
        else {
            self.init()
            return
        }
      
        self.init(
            red: CGFloat(red) / 0xFF,
            green: CGFloat(green) / 0xFF,
            blue: CGFloat(blue) / 0xFF,
            alpha: alpha
        )
    }
  
    convenience init(rgb: Int = 0, alpha: CGFloat = 1.0) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF,
            alpha: alpha
        )
    }
  
    convenience init(rgb: String, alpha: CGFloat = 1.0) {
        var colorHex = rgb.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if (colorHex.hasPrefix("#")) {
            colorHex.remove(at: colorHex.startIndex)
        }

        guard
            colorHex.count == 6,
            let colorInt = Int(colorHex, radix: 16)
        else {
            self.init()
            return
        }
      
        self.init(rgb: colorInt, alpha: alpha)
    }
}
