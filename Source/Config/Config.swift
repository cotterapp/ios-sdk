//
//  Cotter.swift
//  CotterIOS
//
//  Created by Albert Purnama on 2/2/20.
//

import UIKit

// Config class will be passed around in the Cotter SDK
class Config: NSObject {
    static let instance = Config()
  
    var parent: UIViewController!
    var callbackFunc: FinalAuthCallback

    // strings consists text configurations for Cotter
    var strings: LanguageObject = Indonesian() // defaults to indonesian
    var colors: ColorSchemeObject = ColorSchemeObject()
  
    // passwordless configurations
    var PLBaseURL: String? = "https://js.cotter.app"
    var PLScheme: String? = "cotter"
    var PLRedirectURL: String? = "cotter://auth"
    
    private override init() {
        callbackFunc = { (access_token: String, verified: Bool, error: Error?) -> Void in
            print(access_token)
        }
    }
}
