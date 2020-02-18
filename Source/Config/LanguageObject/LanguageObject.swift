//
//  LanguageObject.swift
//  CotterIOS
//
//  Created by Calvin Tjoeng on 2/7/20.
//

import Foundation

// Superclass of all language objects
class LanguageObject: NSObject {
    // non constant text, allowing change of text
    var text: [String: String]
  
    init(text: [String: String]) {
        self.text = text
    }
    
    func set(key:String, value:String) {
        print("setting \(key) to \(value)")
        self.text[key] = value
    }
}
