//
//  Cotter.swift
//  CotterIOS
//
//  Created by Albert Purnama on 2/2/20.
//

import UIKit
import os.log

// Config class will be passed around in the Cotter SDK
class Config: NSObject {
    static let instance = Config()
    
    // callbacks for each individual flows
    var pinEnrollmentCb: FinalAuthCallback
    var updatePINCb: FinalAuthCallback
    var transactionCb: FinalAuthCallback
    var passwordlessCb: (_ identity: CotterIdentity?, _ error: Error?) -> Void
    
    // Config objects passed in from SDK User
    var userInfo: UserInfo? // Required to start reset PIN Process

    // strings consists text configurations for Cotter
    var strings: LanguageObject = Indonesian() // defaults to indonesian
    var colors: ColorSchemeObject = ColorSchemeObject()
    var images: ImageObject = ImageObject()
    var fonts: FontObject = FontObject()
  
    // space configurations
    var baseURL: URL = URL(string: "https://www.cotter.app/api/v0")!
//    var baseURL: URL = URL(string: "http://192.168.86.33:1234/api/v0")!
    
    // passwordless configurations
    var PLBaseURL: String? = "https://js.cotter.app/app"
//    var PLBaseURL: String? = "https://s.js.cotter.app/app"
//    var PLBaseURL: String? = "http://localhost:3000/app"
//    var PLBaseURL: String? = "http://192.168.86.33:3000/app"
    var PLScheme: String? = "cotter"
    var PLRedirectURL: String? = "cotter://auth"
    
    var log: OSLog = OSLog.init(subsystem: "app.cotter.sdk.ios", category: "main")
    
    private override init() {
        let defaultCb = { (access_token: String, error: Error?) -> Void in
            os_log("%{public}@ { access_token: %{public}@ err: %{public}@",
                   log: Config.instance.log, type: .info,
                   #function, access_token, error?.localizedDescription ?? "")
        }
        
        pinEnrollmentCb = defaultCb
        updatePINCb = defaultCb
        transactionCb = defaultCb
        passwordlessCb = {(_ identity: CotterIdentity?, _ error: Error?) in return}
    }
}
