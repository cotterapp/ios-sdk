//
//  CotterViewController.swift
//  CotterIOS
//
//  Created by Albert Purnama on 2/1/20.
//

import UIKit

func defaultCallback(access_token: String) -> Void {
    print(access_token)
}

public class CotterViewController: UIViewController {
    var navControl: UINavigationController?
    
    // the configuration of the view controller
    // this confiiguration can be passed around inside the classes inside the type
    var config: Config?
    
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
    private lazy var pinVC = CotterViewController.cotterStoryboard.instantiateViewController(withIdentifier: "PINViewController")as! PINViewController
    
    // Transaction Corresponding View
    private lazy var transactionPinVC = CotterViewController.transactionStoryboard.instantiateViewController(withIdentifier: "TransactionPINViewController") as! TransactionPINViewController
    
    // Update Profile Corresponding View
    private lazy var updateProfilePinVC = CotterViewController.updateProfileStoryboard.instantiateViewController(withIdentifier: "UpdatePINViewController") as! UpdatePINViewController

    // Xcode 7 & 8
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public convenience init() {
        self.init(
            successCb: defaultCallback,
            apiSecretKey: "",
            apiKeyID: "",
            cotterURL: "",
            userID: ""
        )
    }
    
    public convenience init(successCb: CallbackFunc?, apiSecretKey: String, apiKeyID: String, cotterURL: String, userID: String, configuration: [String: Any]) {
        self.init(
            successCb: successCb,
            apiSecretKey: apiSecretKey,
            apiKeyID: apiKeyID,
            cotterURL: cotterURL,
            userID: userID
        )

        // Check if fields are present in configuration param
        guard let language = configuration["language"] as! String? else { return }

        // Assign fields
        Config.instance.language = language
    }
    
    public init(
        successCb: CallbackFunc?,
        apiSecretKey: String,
        apiKeyID: String,
        cotterURL: String,
        userID: String
    ) {
        Config.instance.callbackFunc = successCb ?? defaultCallback
        
        CotterAPIService.shared.baseURL = URL(string: cotterURL)
        CotterAPIService.shared.apiSecretKey = apiSecretKey
        CotterAPIService.shared.apiKeyID = apiKeyID
        CotterAPIService.shared.userID = userID
        
        // set the ip address
        LocalAuthService.setIPAddr()
        
        super.init(nibName:nil,bundle:nil)
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("loaded Cotter SDK")
    }

    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func start() {
        // initialize the storyboard
        let cotterVC = CotterViewController.cotterStoryboard.instantiateViewController(withIdentifier: "CotterViewController")as! CotterViewController
        
        // push the viewcontroller to the parent navController
        self.navigationController?.pushViewController(cotterVC, animated: true)
    }
    
    // Start of Enrollment Process
    public func startEnrollment(parentNav: UINavigationController, animated: Bool) {
        // push the viewcontroller to the navController
        parentNav.pushViewController(self.pinVC, animated: true)
    }
    
    // Start of Transaction Process
    public func startTransaction(parentNav: UINavigationController, animated: Bool) {
        // Push the viewController to the navController
        parentNav.pushViewController(self.transactionPinVC, animated: true)
    }
    
    // Start of Update Profile Process
    public func startUpdateProfile(parentNav: UINavigationController, animated: Bool) {
        // Set the configuration for the page
        self.updateProfilePinVC.config = self.config
        
        // Push the viewController to the navController
        parentNav.pushViewController(self.updateProfilePinVC, animated: true)
    }
}
