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
        from parent: UIViewController!,
        apiSecretKey: String,
        apiKeyID: String,
        cotterURL: String,
        userID: String,
        onComplete: FinalAuthCallback?,
        configuration: [String: Any]
    ) {
        self.init(
            from: parent,
            apiSecretKey: apiSecretKey,
            apiKeyID: apiKeyID,
            cotterURL: cotterURL,
            onComplete: onComplete
        )
        
        CotterAPIService.shared.userID = userID
        
        // Assign fields if they are present in configuration param
        if let strings = configuration["language"] as! LanguageObject? { Config.instance.strings = strings }
        if let colors = configuration["colors"] as! ColorSchemeObject? { Config.instance.colors = colors }
    }
    
    // default initializer
    public init(
        from parent: UIViewController!,
        apiSecretKey: String,
        apiKeyID: String,
        cotterURL: String,
        onComplete: FinalAuthCallback?
    ) {
        print("initializing Cotter's SDK...")
        Config.instance.parent = parent
        if let onComplete = onComplete { Config.instance.callbackFunc = onComplete }
        
        CotterAPIService.shared.baseURL = URL(string: cotterURL)
        CotterAPIService.shared.apiSecretKey = apiSecretKey
        CotterAPIService.shared.apiKeyID = apiKeyID
        
        // get the ip address on the background
        LocalAuthService.setIPAddr()
    }
    
    // MARK: - Cotter storyboards and VCs
    // cotterStoryboard refers to Cotter.storyboard
    // bundleidentifier can be found when you click Pods general view.
    static var cotterStoryboard = UIStoryboard(name:"Cotter", bundle:Bundle(identifier: "org.cocoapods.Cotter"))
    
    // transactionStoryboard refers to Transaction.storyboard
    // bundleidentifier can be found when you click Pods general view.
    static var transactionStoryboard = UIStoryboard(name: "Transaction", bundle: Bundle(identifier: "org.cocoapods.Cotter"))
    
    // updateProfileStoryboard refers to Transaction.storyboard
    // bundleidentifier can be found when you click Pods general view.
    static var updateProfileStoryboard = UIStoryboard(name: "UpdateProfile", bundle: Bundle(identifier: "org.cocoapods.Cotter"))
    
    // Enrollment Corresponding View
    private lazy var pinVC = Cotter.cotterStoryboard.instantiateViewController(withIdentifier: "PINViewController") as! PINViewController
    
    // Transaction Corresponding View
    private lazy var transactionPinVC = Cotter.transactionStoryboard.instantiateViewController(withIdentifier: "TransactionPINViewController") as! TransactionPINViewController
    
    // Update Profile Corresponding View
    private lazy var updateProfilePinVC = Cotter.updateProfileStoryboard.instantiateViewController(withIdentifier: "UpdatePINViewController") as! UpdatePINViewController
    
    // MARK: - Cotter flows initializers
    // Start of Enrollment Process
    public func startEnrollment(animated: Bool) {
        // push the viewcontroller to the navController
        Config.instance.parent.navigationController?.pushViewController(self.pinVC, animated: true)
    }
    
    // Start of Transaction Process
    public func startTransaction(animated: Bool) {
        // Push the viewController to the navController
        Config.instance.parent.navigationController?.pushViewController(self.transactionPinVC, animated: true)
    }
    
    // Start of Update Profile Process
    public func startUpdateProfile(animated: Bool) {
        // Push the viewController to the navController
        Config.instance.parent.navigationController?.pushViewController(self.updateProfilePinVC, animated: true)
    }
    
    // startPasswordlessLogin starts the login process
    @available(iOS 12.0, *)
    public func startPasswordlessLogin(parentView: UIViewController, input: String, identifierField:String, type:String, directLogin: Bool) {
        var str = "false"
        if directLogin {
            str = "true"
        }
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
