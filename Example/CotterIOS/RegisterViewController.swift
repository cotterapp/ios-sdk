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
    
    
    // upon registration we want to do:
    // 1. Verify user's email
    // 2. Enroll trusted device
    // or
    // 1. Enroll trusted device
    // 2. Verify user's email
    @IBAction func register(_ sender: Any) {
        self.view.endEditing(true)
        guard let input = self.textField.text else { return }
        
        if #available(iOS 12.0, *) {
            /*
            // Use the following logic if you want to verify your users first, then register user for trusted device
            CotterWrapper.cotter?.startPasswordlessLogin(parentView: self, input: userID, identifierField: "email", type: "EMAIL", directLogin: true, cb: { (cotterIdentity, err) in
                if err != nil {
                    print("error on processing passwordlessLogin, ", err)
                    return
                }
                
                guard let cotterIdentity = cotterIdentity else { return }
                
                // then register for passwordless
                Passwordless.shared.registerWith(cotterUser: cotterIdentity.user, cb: { (user: CotterUser?, err:Error?) in
                    if err != nil {
                        // handle error as necessary
                    }
                    if user == nil {
                        // user is unauthorized
                    }
                    // user is authorized
                })
            })
            */
            
            // Flip the logic if you want to register first, then verify the users
            Passwordless.shared.register(identifier: input){ (user: CotterUser?, err:Error?) in
                if err != nil {
                    // handle error as necessary
                    print(err?.localizedDescription)
                    return
                }
                guard let user = user else {
                    print("user is nil")
                    return
                }
                // user is authorized
                CotterWrapper.cotter?.startPasswordlessLogin(
                    parentView: self,
                    input: input,
                    identifierField: "email",
                    type: "EMAIL",
                    directLogin: true,
                    userID: user.id
                ) { (identity, err) in // this is the completion
                    if err != nil {
                        // handle error as necessary
                    }
                    guard let identity = identity else {
                        print("identity is nil")
                        return
                    }
                    print(identity.user)
                }
            }
        } else {
            // Fallback on earlier versions
            Passwordless.shared.register(identifier: input, cb: { (user: CotterUser?, err:Error?) in
                if err != nil {
                    // handle error as necessary
                }
                if user == nil {
                    // user is unauthorized
                }
                // user is authorized
            })
        }
        
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
