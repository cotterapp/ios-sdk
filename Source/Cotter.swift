//
//  Cotter.swift
//  Cotter
//
//  Created by Albert Purnama on 2/11/20.
//

import Foundation
import os
import UIKit
import OneSignal
import UserNotifications

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
            os_log("Cotter.bundle not found!", log: Config.instance.log, type: .fault)
            fatalError("Cotter.bundle not found!")
        }

        guard let resBundle = Bundle(url: bundleURL) else {
            os_log("cannot access Cotter.bundle!", log: Config.instance.log, type: .fault)
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
        os_log("unknown initializer", log: Config.instance.log, type: .fault)
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
        Config.instance.baseURL = URL(string: cotterURL)!
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
        let nav = CotterNavigationViewController(rootViewController: self.pinVC)
        nav.modalPresentationStyle = .fullScreen
        vc.present(nav, animated: true, completion: nil)
    }
    
    // when you want to render PINViewController on startup
    public func getPINViewController(hideClose:Bool, cb: @escaping FinalAuthCallback) -> UIViewController {
        Config.instance.pinEnrollmentCb = cb
        
        // Hide the close button (Optional)
        self.pinVC.hideCloseButton = hideClose
        
        return self.pinVC
    }
    
    // when you want to render TransactionViewController on startup
    public func getTransactionPINViewController(hideClose:Bool, cb: @escaping FinalAuthCallback) -> UIViewController {
        Config.instance.transactionCb = cb
        
        // Hide the close button (Optional)
        self.transactionPinVC.hideCloseButton = hideClose
        
        return self.transactionPinVC
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
            vc.navigationController?.pushViewController(self.transactionPinVC, animated: true)
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
        authMethod: AuthMethod? = nil,
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
            userID: userID,
            authMethod: authMethod
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
        os_log(
            "%{public}@ { baseURL: %{public}@, apiKey: %{public}@ }",
            log: Config.instance.log, type: .info,
            #function, Config.instance.baseURL.absoluteString, apiKeyID
        )
        
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
        if let fonts = configuration["fonts"] as! FontObject? { Config.instance.fonts = fonts }
        if let name = configuration["name"] as! String?, let sendingMethod = configuration["sendingMethod"] as! String?, let sendingDestination = configuration["sendingDestination"] as! String? {
            Config.instance.userInfo = UserInfo(name: name, sendingMethod: sendingMethod, sendingDestination: sendingDestination)
        }
    }
    
    // configureWithLaunchOptions configures cotter with notification services (OneSignal)
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
        
        // we handle notification from killed state by checking if the user has any pending event
        // everytime the app loads.
        if let userID = getLoggedInUserID() {
            Passwordless.shared.checkEvent(identifier: userID)
        }
    }
    
    // configureOneSignal configure cotter's onesignal SDK with launchOptions provided
    private static func configureOneSignal(launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        let onesignalInitSettings = [kOSSettingsKeyAutoPrompt: false,
         kOSSettingsKeyInAppLaunchURL: true]

        func notifCb(res: CotterResult<CotterNotificationCredential>) {
            switch res {
                case .success(let cred):
                    // if appID is not setup don't use initiate OneSignal
                    if cred.appID == "" { return }
                    OneSignal.setLocationShared(false)
                    OneSignal.initWithLaunchOptions(launchOptions,
                                                  appId: cred.appID,
                                                  handleNotificationReceived: nil,
                                                  handleNotificationAction: notificationOpenedHandler,
                                                  settings: onesignalInitSettings)
                    OneSignal.inFocusDisplayType = .notification
                
                    if let userID = Cotter.getLoggedInUserID() {
                        guard let pubKey = KeyStore.trusted(userID: userID).pubKey else {
                            return
                        }
                        
                        let pubKeyBase64 = CryptoUtil.keyToBase64(pubKey: pubKey)
                        
                        OneSignal.setExternalUserId(pubKeyBase64)
                    }
                case .failure(let err):
                    os_log("%{public}@ failure configureOneSignal, err: %{public}@",
                        log: Config.instance.log, type: .error,
                        #function, err.localizedDescription)
            }
        }
        CotterAPIService.shared.getNotificationAppID(cb:notifCb)
    }
}

// OAauth tools
extension Cotter {
    static public func getAccessToken() -> String? {
        let t = getCotterDefaultToken()
        
        guard let token = t else { return nil }
        
        guard let accessToken = decodeBase64AccessTokenJWT(token.accessToken) else { return nil }
        
        if Int(NSDate().timeIntervalSince1970) > accessToken.exp {
            // access token expired. refetch token, this function is synchronous
            Cotter.refreshToken()
            
            // refetch token
            let newToken = getCotterDefaultToken()
            
            return newToken?.accessToken
        }
        
        return token.accessToken
    }
    
    // refresh token is synchronous.
    static public func refreshToken() {
        let t = getCotterDefaultToken()
        
        guard let token = t else { return }
        
        let group = DispatchGroup()
        
        group.enter()
        
        CotterAPIService.shared.refreshTokens(refreshToken: token.refreshToken) { (response) in
            switch(response) {
            case .success(var tkn):
                // persist the refresh token
                tkn.refreshToken = token.refreshToken
                setCotterDefaultToken(token: tkn)
            case .failure(let err):
                os_log("%{public}@ err: %{public}@",
                    log: Config.instance.log, type: .error,
                    #function, err.localizedDescription)
            }
            
            group.leave()
        }
    }
}

// login utilities
extension Cotter {
    static public func getLoggedInUserID() -> String? {
        // get the ID of the token
        guard let accessToken = Cotter.getAccessToken() else {
            return nil
        }
        
        guard let t = decodeBase64AccessTokenJWT(accessToken) else {
            return nil
        }
        
        return t.sub
    }
    
    static public func logout() {
        // remove onesignal notification,
        // so this phone will not receive any notification for this user
        OneSignal.removeExternalUserId()
        
        // purge oauth tokens
        deleteCotterDefaultToken()
    }
}

func transformCb(parent: UIViewController, cb: @escaping FinalAuthCallback) -> FinalAuthCallback {
    return { (token:String, err: Error?) in
        // to dismiss views
        parent.presentedViewController?.dismiss(animated: true, completion: nil)
        parent.navigationController?.popToViewController(parent, animated: false)
        parent.setOriginalStatusBarStyle()
        cb(token, err)
    }
}

func notificationOpenedHandler( result: OSNotificationOpenedResult? ) {
    // This block gets called when the user reacts to a notification received
    let payload: OSNotificationPayload = result!.notification.payload
    
    if payload.additionalData != nil {
        let customData = payload.additionalData
        if customData?["cotter"] != nil, let authMethod = customData?["auth_method"] as! String?, authMethod == "TRUSTED_DEVICE" {
            guard let userID = Cotter.getLoggedInUserID() else {
                return
            }
            Passwordless.shared.checkEvent(identifier: userID)
        }
    }
}
