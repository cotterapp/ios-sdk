//
//  LanguageObject.swift
//  CotterIOS
//
//  Created by Calvin Tjoeng on 2/7/20.
//

import Foundation

// Superclass of all language objects
class LanguageObject: NSObject {
    let text: [String: String]
  
    init(text: [String: String]) {
        self.text = text
    }
}
