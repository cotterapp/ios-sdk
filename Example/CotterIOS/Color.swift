//
//  Color.swift
//  CotterIOS_Example
//
//  Created by Albert Purnama on 2/29/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit

class CotterColor {
    static let colors:[UIColor] = [
        UIColor(red: 129, green: 75, blue: 237), // purple
        UIColor(red: 248, green: 80, blue: 96) // orange
    ]
    
    static let size = colors.count
    
    public static func random() -> UIColor {

        let i = arc4random()
        let idx = Int(i) % size
        
        return colors[idx]
    }
}

extension UIColor {
    static func random() -> UIColor {
        return CotterColor.random()
    }
}
