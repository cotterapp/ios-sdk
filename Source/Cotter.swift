//
//  Cotter.swift
//  Cotter
//
//  Created by Albert Purnama on 2/11/20.
//

import Foundation
import UIKit
import OneSignal

public class Cotter {
    // this variable is needed to retain the object of ASWebAuthentication,
    // otherwise the login default prompt will be closed immediately because
    // Passwordless object is deallocated
    var passwordless: Any?
    
    // this variable is needed to revert the UI Status Bar Style
    // back to its original
    @available(iOS 12.0, *)
    static var originalInterfaceStyle: UIUserInterfaceStyle?
    
    // userID inside a Cotter instance is always tied to CotterAPIService's userID.
    // currently there is no reason to separate the userID
    public var userID:String {
        set {
            CotterAPIService.shared.userID = newValue
        }
        
        get {
            return CotterAPIService.shared.userID ?? ""
        }
    }
    
    // Resource Bundle Initialization
    // Taken from: https://stackoverflow.com/questions/35692265/how-to-load-resource-in-cocoapods-resource-bundle
    static var resourceBundle: Bundle = {
        // Set the resource bundle
        let frameworkBundle = Bundle(for: Cotter.self)
        guard let bundleURL = frameworkBundle.url(forResource: "Cotter", withExtension: "bundle") else {
            fatalError("Cotter.bundle not found!")
        }

        guard let resBundle = Bundle(url: bundleURL) else {
            fatalError("cannot access Cotter.bundle!")
        }

        return resBundle
    }()
    
    public static var PLBaseURL: String? {
        set {
            Config.instance.PLBaseURL = newValue
        }
        get {
            return Config.instance.PLBaseURL
        }
    }
    
    // default initializers, this should not be called without proper configurationss
    @available(*, unavailable, message: "Unknown initializer")
    public init() {
        print("Unknown initializer")
    }
    
    // initializer with configuration
    public convenience init(
        apiSecretKey: String,
        apiKeyID: String,
        cotterURL: String,
        userID: String,
        configuration: [String: Any]
    ) {
        self.init(
            apiSecretKey: apiSecretKey,
            apiKeyID: apiKeyID,
            cotterURL: cotterURL
        )
        
        CotterAPIService.shared.userID = userID
        
        Cotter.setConfiguration(configuration: configuration)
    }
    
    // default initializer
    public init(
        apiSecretKey: String,
        apiKeyID: String,
        cotterURL: String
    ) {
        print("initializing Cotter's SDK...")
        CotterAPIService.shared.baseURL = URL(string: cotterURL)
        CotterAPIService.shared.apiSecretKey = apiSecretKey
        CotterAPIService.shared.apiKeyID = apiKeyID
        
        // get the ip address on the background
        LocalAuthService.setIPAddr()
    }
    
    // MARK: - Cotter storyboards and VCs
    // cotterStoryboard refers to Cotter.storyboard
    // bundleidentifier can be found when you click Pods general view.
    static var cotterStoryboard = UIStoryboard(name:"Cotter", bundle: Cotter.resourceBundle)
    
    // transactionStoryboard refers to Transaction.storyboard
    // bundleidentifier can be found when you click Pods general view.
    static var transactionStoryboard = UIStoryboard(name: "Transaction", bundle: Cotter.resourceBundle)
    
    // updateProfileStoryboard refers to Transaction.storyboard
    // bundleidentifier can be found when you click Pods general view.
    static var updateProfileStoryboard = UIStoryboard(name: "UpdateProfile", bundle: Cotter.resourceBundle)
    
    // Enrollment Corresponding View
    private lazy var pinVC = Cotter.cotterStoryboard.instantiateViewController(withIdentifier: "PINViewController") as! PINViewController
    
    // Transaction Corresponding View
    private lazy var transactionPinVC = Cotter.transactionStoryboard.instantiateViewController(withIdentifier: "TransactionPINViewController") as! TransactionPINViewController
    
    // Update Profile Corresponding View
    private lazy var updateProfilePinVC = Cotter.updateProfileStoryboard.instantiateViewController(withIdentifier: "UpdatePINViewController") as! UpdatePINViewController
    
    // MARK: - Cotter flows initializers
    // Start of Enrollment Process
    public func startEnrollment(
        vc: UIViewController,
        animated: Bool,
        cb: @escaping FinalAuthCallback,
        hideClose:Bool = false
    ) {
        // Hide the close button (Optional)
        self.pinVC.hideCloseButton = hideClose
        
        Config.instance.pinEnrollmentCb = transformCb(parent: vc, cb: cb)
        
        // push the viewcontroller to the navController
        let nav = UINavigationController(rootViewController: self.pinVC)
        nav.modalPresentationStyle = .fullScreen
        vc.present(nav, animated: true, completion: nil)
    }
    
    // Start of Transaction Process
    public func startTransaction(
        vc: UIViewController,
        animated: Bool,
        cb: @escaping FinalAuthCallback,
        hideClose: Bool = false,
        name: String? = nil,
        sendingMethod: String? = nil,
        sendingDestination: String? = nil
    ) {
        // Hide the close button
        self.transactionPinVC.hideCloseButton = hideClose
        
        Config.instance.transactionCb = transformCb(parent: vc, cb: cb)
        
        // Add user info if exist - name, sending method, etc.
        if let name = name, let sendingMethod = sendingMethod, let sendingDestination = sendingDestination {
            Config.instance.userInfo = UserInfo(name: name, sendingMethod: sendingMethod, sendingDestination: sendingDestination)
        }
        
        // if you want to show close button, need to wrap it inside a navigation controller
        if !hideClose {
            let nav = UINavigationController(rootViewController: self.transactionPinVC)
            nav.modalPresentationStyle = .fullScreen
            vc.present(nav, animated: true, completion: nil)
        } else {
            self.transactionPinVC.modalPresentationStyle = .fullScreen
            vc.present(self.transactionPinVC, animated: true, completion: nil)
        }
    }
    
    // Start of Update Profile Process
    public func startUpdateProfile(
        vc: UIViewController,
        animated: Bool,
        cb: @escaping FinalAuthCallback,
        hideClose:Bool = false
    ) {
        Config.instance.updatePINCb = transformCb(parent: vc, cb: cb)
        
        // Push the viewController to the navController
        vc.navigationController?.pushViewController(self.updateProfilePinVC, animated: animated)
    }
    
    // startPasswordlessLogin starts the login process
    @available(iOS 12.0, *)
    public func startPasswordlessLogin(
        parentView: UIViewController,
        input: String,
        identifierField:String,
        type:String,
        directLogin: Bool,
        userID: String? = nil,
        cb: @escaping (_ identity: CotterIdentity?, _ error: Error?) -> Void
    ) {
        var str = "false"
        if directLogin {
            str = "true"
        }
        
        Config.instance.passwordlessCb = { (_ identity: CotterIdentity?, _ error: Error?) in
            parentView.navigationController?.popToViewController(parentView, animated: false)
            parentView.setOriginalStatusBarStyle()
            cb(identity, error)
        }
        
        self.passwordless = CrossApp(
            view: parentView,
            input: input,
            identifierField: identifierField,
            type: type,
            directLogin: str,
            userID: userID
        )
    }
    
    // setText sets the string based on the key string
    public func setText(for key: String, to value: String) {
        Config.instance.strings.setText(for: key, to: value)
    }
    
    // MARK: - Trusted Devices
    
    public func loginWithTrustedDevice(
        vc: UIViewController,
        cb: @escaping FinalAuthCallback
    ) {
        TrustedDevice(vc: vc, cb: cb).login(userID: self.userID)
    }
    
    // getEventTrustedDevice manually fetches any event for a specified userID
    public func getEventTrustedDevice(
        vc: UIViewController,
        cb: @escaping FinalAuthCallback
    ) {
        TrustedDevice(vc:vc, cb:cb).checkEvent(userID: self.userID)
    }
    
    public func registerNewDevice(
        vc: UIViewController,
        cb: @escaping FinalAuthCallback
    ) {
        TrustedDevice(vc:vc, cb:cb).registerDevice(userID: self.userID)
    }
    
    public func scanNewDevice(
        vc: UIViewController,
        cb: @escaping FinalAuthCallback
    ) {
        TrustedDevice(vc:vc, cb:cb).scanNewDevice(userID: self.userID)
    }
    
    public func removeTrustedDevice(
        vc: UIViewController,
        cb: @escaping FinalAuthCallback
    ) {
        TrustedDevice(vc:vc, cb:cb).removeDevice(userID: self.userID)
    }
    
    // MARK: - lean configurations
    
    // configure: simple initialization config
    public static func configure(
        apiSecretKey: String,
        apiKeyID: String,
        configuration: [String:Any] = [:]
    ) {
        print("configuring Cotter's object...")
//        CotterAPIService.shared.baseURL = URL(string: "https://www.cotter.app/api/v0")!
//        CotterAPIService.shared.baseURL = URL(string: "https://s.www.cotter.app/api/v0")!
        CotterAPIService.shared.baseURL = URL(string: "http://localhost:1234/api/v0")!
//        CotterAPIService.shared.baseURL = URL(string:"http://192.168.86.36:1234/api/v0")!
        CotterAPIService.shared.apiSecretKey = apiSecretKey
        CotterAPIService.shared.apiKeyID = apiKeyID
        
        // get the ip address on the background
        LocalAuthService.setIPAddr()
        
        Cotter.setConfiguration(configuration: configuration)
    }
    
    // setConfiguration accepts a configuration object then set the appropriate configuration fields inside the
    // config instance.
    private static func setConfiguration(configuration: [String:Any] = [:]) {
        // Assign fields if they are present in configuration param
        if let strings = configuration["language"] as! LanguageObject? { Config.instance.strings = strings }
        if let images = configuration["images"] as! ImageObject? {
            Config.instance.images = images }
        if let colors = configuration["colors"] as! ColorSchemeObject? { Config.instance.colors = colors }
        if let name = configuration["name"] as! String?, let sendingMethod = configuration["sendingMethod"] as! String?, let sendingDestination = configuration["sendingDestination"] as! String? {
            Config.instance.userInfo = UserInfo(name: name, sendingMethod: sendingMethod, sendingDestination: sendingDestination)
        }
    }
    
    public static func configureWithLaunchOptions(
        launchOptions: [UIApplication.LaunchOptionsKey: Any]?,
        apiSecretKey: String,
        apiKeyID: String,
        configuration: [String:Any] = [:]
    ) {
        // configure stuff
        Cotter.configure(apiSecretKey: apiSecretKey, apiKeyID: apiKeyID, configuration: configuration)
        
        // configure onesignal
        Cotter.configureOneSignal(launchOptions: launchOptions)
    }
    
    // configureOneSignal configure cotter's onesignal SDK with launchOptions provided
    private static func configureOneSignal(launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        let onesignalInitSettings = [kOSSettingsKeyAutoPrompt: false,
         kOSSettingsKeyInAppLaunchURL: true]

        func notifCb(res: CotterResult<CotterNotificationCredential>) {
            switch res {
                case .success(let cred):
                    OneSignal.initWithLaunchOptions(launchOptions,
                                                  appId: cred.appID,
                                                  handleNotificationReceived: nil,
                                                  handleNotificationAction: nil,
                                                  settings: onesignalInitSettings)

                    OneSignal.inFocusDisplayType = OSNotificationDisplayType.notification
                  
                case .failure(let err):
                    print(err)
            }
        }
        CotterAPIService.shared.getNotificationAppID(cb:notifCb)
    }
}

func transformCb(parent: UIViewController, cb: @escaping FinalAuthCallback) -> FinalAuthCallback {
    return { (token:String, err: Error?) in
        // NEW: - untuk dismis prensented VC
        parent.dismiss(animated: true, completion: nil)
        parent.navigationController?.popToViewController(parent, animated: false)
        parent.setOriginalStatusBarStyle()
        cb(token, err)
    }
}
