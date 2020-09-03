//
//  LanguageObject.swift
//  CotterIOS
//
//  Created by Calvin Tjoeng on 2/7/20.
//

import Foundation

// Superclass of all language objects
public class LanguageObject: NSObject {
    // non constant text, allowing change of text
    var text: [String: String]
  
    init(text: [String: String]) {
        self.text = text
    }
    
    public func setText(for key: String, to value: String) {
        self.text[key] = value
    }
}
