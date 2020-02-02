//
//  CotterViewController.swift
//  CotterIOS
//
//  Created by Albert Purnama on 2/1/20.
//

import UIKit

public class CotterViewController: UIViewController {
    var parentNavController: UINavigationController?
    var onSuccessView: UIViewController?
    var apiSecretKey: String="", apiKeyID: String="", cotterURL: String="", userID: String=""
    var navControl: UINavigationController?
    
    // the configuration of the view controller
    // this confiiguration can be passed around inside the classes inside the type
    var config: Config?
    
    // cotterStoryboard refers to Cotter.storyboard
    // bundleidentifier can be found when you click Pods general view.
    static var cotterStoryboard = UIStoryboard(name:"Cotter", bundle:Bundle(identifier: "org.cocoapods.CotterIOS"))

    // Xcode 7 & 8
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public convenience init() {
        self.init(
            nil,
            nil,
            "",
            "",
            "",
            ""
        )
    }
    
    public init(_ callbackNav: UINavigationController?, _ callbackView: UIViewController?, _ apiSecretKey: String, _ apiKeyID: String, _ cotterURL: String, _ userID: String) {
        self.config = Config()
        self.config!.parentNav = callbackNav
        self.config!.callbackView = callbackView
        self.config!.apiSecretKey = apiSecretKey
        self.config!.cotterURL = cotterURL
        self.config!.userID = userID
        
        // maybe these can be removed, and we can only use the self.config
        self.parentNavController = callbackNav
        self.onSuccessView = callbackView
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
        self.parentNavController?.pushViewController(cotterVC, animated: true)
    }
    
    public func startEnrollment() {
        // initialize the storyboard
        let cotterVC = CotterViewController.cotterStoryboard.instantiateViewController(withIdentifier: "PINViewController")as! PINViewController
        
        // set the configuration for the page
        cotterVC.config = self.config
        
        // push the viewcontroller to the parent navController
        self.parentNavController?.pushViewController(cotterVC, animated: true)
    }
}
