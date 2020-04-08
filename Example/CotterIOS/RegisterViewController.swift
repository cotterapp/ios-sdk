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

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.infoLabel.text = ""
    }
    
    private func setup() {
        self.setupTrustedDevice()
    }
    
    @IBAction func register(_ sender: Any) {
        guard let userID = self.textField.text else { return }

        CotterAPIService.shared.registerUser(userID: userID, cb: { resp in
            switch resp {
            case .success(let usr):
                self.infoLabel.text = "Successfully registered user \(usr.clientUserID)"
                self.userID = userID
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    self.setup()
                    self.performSegue(withIdentifier: "segueRegisterHome", sender: self)
                }
            case .failure(let err):
                self.infoLabel.text = err.localizedDescription
            }
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        switch(identifier) {
        case "segueRegisterHome":
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

extension RegisterViewController {
    private func setupTrustedDevice() {
        func enrollTrustedDevice(_ response: CotterResult<CotterUser>){
            switch response{
            case .success(let user):
                print("[setupTrustedDevice] successfully registered: \(user.enrolled)")
                
            case .failure(let err):
                // you can put exhaustive error handling here
                print(err.localizedDescription)
            }
        }
        
        CotterAPIService.shared.enrollTrustedDevice(userID: self.userID, cb: enrollTrustedDevice)
    }
}
