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

    // strings consists text configurations for Cotter
    var strings: LanguageObject = Indonesian() // defaults to indonesian
    
    // colors consists color configurations for Cotter
    var colors: ColorObject = DefaultColor()
  
    // passwordless configurations
    var PLBaseURL: String? = "https://js.cotter.app"
    var PLScheme: String? = "cotter"
    var PLRedirectURL: String? = "cotter://auth"
    
    private override init() {}
}
