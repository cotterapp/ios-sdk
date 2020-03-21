//
//  Cotter.swift
//  Cotter
//
//  Created by Albert Purnama on 2/11/20.
//

import Foundation
import UIKit

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
        let bundleURL = frameworkBundle.resourceURL?.appendingPathComponent("Cotter.bundle")
        return Bundle(url: bundleURL!)!
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
        
        // Assign fields if they are present in configuration param
        if let strings = configuration["language"] as! LanguageObject? { Config.instance.strings = strings }
        if let images = configuration["images"] as! ImageObject? {
            Config.instance.images = images }
        if let colors = configuration["colors"] as! ColorSchemeObject? { Config.instance.colors = colors }
        if let name = configuration["name"] as! String?, let sendingMethod = configuration["sendingMethod"] as! String?, let sendingDestination = configuration["sendingDestination"] as! String? {
            Config.instance.userInfo = UserInfo(name: name, sendingMethod: sendingMethod, sendingDestination: sendingDestination)
        }
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
        vc.navigationController?.pushViewController(self.pinVC, animated: animated)
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
        
        // Push the viewController to the navController
        vc.navigationController?.pushViewController(self.transactionPinVC, animated: animated)
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
    public func startPasswordlessLogin(parentView: UIViewController, input: String, identifierField:String, type:String, directLogin: Bool, cb: @escaping FinalAuthCallback) {
        var str = "false"
        if directLogin {
            str = "true"
        }
        
        Config.instance.passwordlessCb = transformCb(parent: parentView, cb: cb)
        
        self.passwordless = Passwordless(
            view: parentView,
            input: input,
            identifierField: identifierField,
            type: type,
            directLogin: str
        )
    }
    
    // setText sets the string based on the key string
    public func setText(for key: String, to value: String) {
        Config.instance.strings.setText(for: key, to: value)
    }
}

func transformCb(parent: UIViewController, cb: @escaping FinalAuthCallback) -> FinalAuthCallback {
    return { (token:String, err: Error?) in
        parent.navigationController?.popToViewController(parent, animated: false)
        parent.setOriginalStatusBarStyle()
        cb(token, err)
    }
}

// TODO: Delete this soon
extension Cotter {
    public func clearKeys() {
        print("clearing keys from Cotter..")
        do {
            try KeyStore.clearKeys()
        } catch {
            print(error.localizedDescription)
        }
    }
}
