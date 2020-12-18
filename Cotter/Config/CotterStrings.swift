//
//  CotterStrings.swift
//  CotterIOS
//
//  Created by Albert Purnama on 2/6/20.
//

// Strings will be used inside the classes
class CotterStrings: NSObject {
    static let instance = CotterStrings()
  
    private override init() {}
  
    func getText(for key: String) -> String {
        return Config.instance.strings.text[key] ?? "Text not found."
    }
}
