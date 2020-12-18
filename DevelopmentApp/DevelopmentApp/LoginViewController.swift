//
//  LoginViewController.swift
//  CotterIOS_Example
//
//  Created by Albert Purnama on 2/13/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import Cotter

@available(iOS 12.0, *)
class LoginViewController: UIViewController {
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var phoneInput: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("loaded LoginViewController")
    }
    
    @IBAction func login(_ sender: Any) {
        // get the text input
        let textInput = self.phoneInput.text ?? ""
        
        CotterWrapper.cotter?.startPasswordlessLogin(
            parentView: self,
            input: textInput,
            identifierField: "email",
            type: "EMAIL",
            directLogin: true,
            authMethod: .magicLink
        ){ (identity , err) in return} // do nothing callback
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
