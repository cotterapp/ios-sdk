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
    
    // callbacks for each individual flows
    var pinEnrollmentCb: FinalAuthCallback
    var updatePINCb: FinalAuthCallback
    var transactionCb: FinalAuthCallback
    var passwordlessCb: FinalAuthCallback

    // strings consists text configurations for Cotter
    var strings: LanguageObject = Indonesian() // defaults to indonesian
    var colors: ColorSchemeObject = ColorSchemeObject()
    var images: ImageObject = ImageObject()
  
    // passwordless configurations
    var PLBaseURL: String? = "https://js.cotter.app/app"
    var PLScheme: String? = "cotter"
    var PLRedirectURL: String? = "cotter://auth"
    
    private override init() {
        let defaultCb = { (access_token: String, error: Error?) -> Void in
            print(access_token)
        }
        
        pinEnrollmentCb = defaultCb
        updatePINCb = defaultCb
        transactionCb = defaultCb
        passwordlessCb = defaultCb
    }
}
