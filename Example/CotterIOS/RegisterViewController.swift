//
//  RegisterViewController.swift
//  CotterIOS_Example
//
//  Created by Albert Purnama on 3/26/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import Cotter

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.infoLabel.text = ""
    }
    
    
    @IBAction func register(_ sender: Any) {
        self.view.endEditing(true)
        guard let userID = self.textField.text else { return }
        
        Passwordless.shared.register(identifier: userID, cb: { (token: CotterOAuthToken?, err:Error?) in
            if err != nil {
                // handle error as necessary
            }
            if token == nil {
                // user is unauthorized
            }
            // user is authorized
        })
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
