//
//  LoginViewController.swift
//  CotterIOS_Example
//
//  Created by Albert Purnama on 2/13/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var phoneInput: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("loaded LoginViewController")
    }
    
    @IBAction func login(_ sender: Any) {
        // get the text input
//        let textInput = self.phoneInput.text ?? ""
        let textInput = "+19252386500"
        
        print("logging in \(textInput)")
        CotterWrapper.cotter?.startPasswordlessLogin(
            parentView: self,
            input: textInput,
            identifierField: "phone",
            type: "PHONE",
            directLogin: true
        )
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
