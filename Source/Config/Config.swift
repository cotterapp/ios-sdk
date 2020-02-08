//
//  Cotter.swift
//  CotterIOS
//
//  Created by Albert Purnama on 2/2/20.
//

import UIKit

// CallbackFunc takes in a string which is the access token and returns a void
public typealias CallbackFunc = (String) -> Void

// Config class will be passed around in the Cotter SDK
class Config: NSObject {
    static let instance = Config()
  
    var parentNav: UINavigationController?
    var callbackView: UIViewController?
    var callbackFunc: CallbackFunc?
  
    var language: String? = "Indonesian"
    var languageObject: LanguageObject {
        switch Config.instance.language {
            case "Indonesian":
                return Indonesian()
            case "English":
                return English()
            default:
                return Indonesian()
        }
    }
  
    private override init() {}
}
