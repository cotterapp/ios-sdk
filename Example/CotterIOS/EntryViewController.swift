//
//  EntryViewController.swift
//  CotterIOS_Example
//
//  Created by Albert Purnama on 3/26/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import Cotter

class EntryViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var loginButton: BasicButton!
    @IBOutlet weak var enrollTrustedForUserButton: BasicButton!
    
    var userID:String {
        set {
            CotterWrapper.cotter?.userID = newValue
        }
        
        get {
            return CotterWrapper.cotter?.userID ?? ""  
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func login(_ sender: Any) {
        guard let userID = self.textField.text else { return }
        self.view.endEditing(true)
        print("logging in")
        
        Passwordless.shared.parentVC = self
        Passwordless.shared.login(identifier: userID, cb: { (token: CotterOAuthToken?, err:Error?) in
            if err != nil {
                // handle error as necessary
                self.infoLabel.text = err?.localizedDescription
                return
            }
            if token == nil {
                // user is unauthorized
                self.infoLabel.text = "user is unauthorized"
                return
            }
            
            // set the userID
            self.userID = userID
            
            // user is authorized
            self.performSegue(withIdentifier: "segueToHome", sender: nil)
        })
    }
    
    @IBAction func checkEvent(_ sender: Any) {
        guard let userID = self.textField.text else { return }
        self.view.endEditing(true)
        Passwordless.shared.parentVC = self
        Passwordless.shared.checkEvent(identifier:userID)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        switch(identifier) {
        case "segueToHome":
            print("prepare segue for ViewController")
            let vc = segue.destination as! ViewController
            vc.userID = self.userID
        default:
            print("unknown segue identifier: \(identifier)")
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

extension EntryViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}

func randomString(length: Int) -> String {
  let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
  return String((0..<length).map{ _ in letters.randomElement()! })
}
