//
//  UserCheckViewController.swift
//  CotterIOS_Example
//
//  Created by Albert Purnama on 2/27/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import Cotter

class UserCheckViewController: UIViewController {

    @IBOutlet weak var userDetailsLabel: UILabel!
    @IBOutlet weak var userIDLabel: UILabel!
    @IBOutlet weak var errorLabel: UILabel!
    
    var userID = ""
    
    var cb:ResultCallback<CotterUser> = DefaultResultCallback
    
    override func viewDidAppear(_ animated: Bool) {
        self.errorLabel.text = ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.userIDLabel.text = "Client User ID: \(self.userID)"
        

        func enrollCb(response: CotterResult<CotterUser>) {
            switch response {
            case .success(let resp):
                self.userDetailsLabel.text = resp.enrolled?.joined(separator: ", ")
            case .failure(let err):
                // we can handle multiple error results here
                switch err {
                case CotterAPIError.status(code: 500):
                    print("internal server error")
                case CotterAPIError.status(code: 404):
                    print("user not found")
                default:
                    print(err.localizedDescription)
                }
            }
        }
        
        self.cb = enrollCb
        
        CotterAPIService.shared.getUser(userID:self.userID, cb:cb)
        
        getBiometricStatus()
        
        getTrustedDeviceStatus()
    }
    
    @IBOutlet weak var bioStatusLabel: UILabel!
    
    func getBiometricStatus() {
        func cb(response: CotterResult<EnrolledMethods>) {
            switch response {
            case .success(let resp):
                var status = "false"
                if resp.enrolled && resp.method == "BIOMETRIC" {
                    status = "true"
                }
                self.bioStatusLabel.text = status
            case .failure(let err):
                self.errorLabel.text = err.localizedDescription
            }
        }
        CotterAPIService.shared.getBiometricStatus(cb: cb)
    }
    
    
    @IBOutlet weak var trustedStatusLabel: UILabel!
    
    func getTrustedDeviceStatus() {
        func cb(response: CotterResult<EnrolledMethods>) {
            switch response {
            case .success(let resp):
                var status = "false"
                if resp.enrolled && resp.method == "TRUSTED_DEVICE" {
                    status = "true"
                }
                self.trustedStatusLabel.text = status
            case .failure(let err):
                self.errorLabel.text = err.localizedDescription
            }
        }
        CotterAPIService.shared.getTrustedDeviceStatus(clientUserID: self.userID, cb: cb)
    }
    
    @IBOutlet weak var textFieldUserID: UITextField!
    
    @IBAction func checkAction(_ sender: Any) {
        guard let userID = self.textFieldUserID.text else { return }
        CotterAPIService.shared.getUser(userID:userID, cb:cb)
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
