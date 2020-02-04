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
    var onSuccessView: UIViewController?
    var apiSecretKey: String="", apiKeyID: String="", cotterURL: String="", userID: String=""
    var navControl: UINavigationController?
    
    // the configuration of the view controller
    // this confiiguration can be passed around inside the classes inside the type
    var config: Config?
    
    // cotterStoryboard refers to Cotter.storyboard
    // bundleidentifier can be found when you click Pods general view.
    static var cotterStoryboard = UIStoryboard(name:"Cotter", bundle:Bundle(identifier: "org.cocoapods.CotterIOS"))
    
    private lazy var pinVC = CotterViewController.cotterStoryboard.instantiateViewController(withIdentifier: "PINViewController")as! PINViewController

    // Xcode 7 & 8
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public convenience init() {
        self.init(
            defaultCallback,
            "",
            "",
            "",
            ""
        )
    }
    
    public init(_ successCb: CallbackFunc?, _ apiSecretKey: String, _ apiKeyID: String, _ cotterURL: String, _ userID: String) {
        self.config = Config()
        self.config!.apiSecretKey = apiSecretKey
        self.config!.cotterURL = cotterURL
        self.config!.userID = userID
        self.config!.callbackFunc = successCb
        
        CotterAPIService.shared.setBaseURL(url: cotterURL)
        CotterAPIService.shared.setKeyPair(keyID: apiKeyID, secretKey: apiSecretKey)
        CotterAPIService.shared.setUserID(userID: userID)
        
        // maybe these can be removed, and we can only use the self.config
        self.apiSecretKey = apiSecretKey
        self.apiKeyID = apiKeyID
        self.cotterURL = cotterURL
        self.userID = userID
        
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
    
    public func startEnrollment(parentNav: UINavigationController, animated: Bool) {
        // set the configuration for the page
        self.pinVC.config = self.config
        
        // push the viewcontroller to the navController
        parentNav.pushViewController(self.pinVC, animated: true)
    }
}
