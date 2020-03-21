//
//  TrustedDeviceViewController.swift
//  CotterIOS_Example
//
//  Created by Albert Purnama on 3/20/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import Cotter

class TrustedDeviceViewController: UIViewController {
    
    var userID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    // textLabel is the return values of each button press
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var userIDTextField: UITextField!
    
    @IBAction func getNewEvent(_ sender: Any) {
        func cb(response: CotterResult<CotterEvent?>) {
            switch response {
            case .success(let resp):
                if resp != nil {
                    let jsonData = try! JSONEncoder().encode(resp)
                    let jsonString = String(data: jsonData, encoding: .utf8)!
                    self.textLabel.text = jsonString
                    return
                }
                self.textLabel.text = "No new Events"
            case .failure(let err):
                print("failed")
                print(err.localizedDescription)
            }
        }
        CotterAPIService.shared.getNewEvent(userID: self.userID, cb: cb)
    }
    
    @IBAction func requestAuth(_ sender: Any) {
        func cb(response: CotterResult<CotterEvent>) {
            switch response {
            case .success(let resp):
                self.textLabel.text = "Requested: \(resp)"
            case .failure(let err):
                print("failed")
                print(err.localizedDescription)
            }
        }
        CotterAPIService.shared.reqAuth(
            userID: self.userID,
            event: "REQUEST_AUTH_MANUAL",
            cb: cb
        )
    }
    
    @IBAction func getNewEventFor(_ sender: Any) {
        guard let userID = self.userIDTextField.text else { return }
        
        func cb(response: CotterResult<CotterEvent?>) {
            switch response {
            case .success(let resp):
                if resp != nil {
                    let jsonData = try! JSONEncoder().encode(resp)
                    let jsonString = String(data: jsonData, encoding: .utf8)!
                    self.textLabel.text = jsonString
                    return
                }
                self.textLabel.text = "No new Events"
            case .failure(let err):
                print("failed")
                print(err.localizedDescription)
            }
        }
        CotterAPIService.shared.getNewEvent(userID: userID, cb: cb)
    }
    
    @IBAction func loginTrusted(_ sender: Any) {
        guard let userID = self.userIDTextField.text else { return }
        
        func cb(response: CotterResult<CotterEvent>) {
            switch response {
            case .success(let resp):
                let jsonData = try! JSONEncoder().encode(resp)
                let jsonString = String(data: jsonData, encoding: .utf8)!
                self.textLabel.text = jsonString
            case .failure(let err):
                print("failed")
                print(err.localizedDescription)
            }
        }
        
        CotterAPIService.shared.reqAuth(
            userID: userID,
            event: "LOGIN_WITH_TRUSTED_DEVICE",
            cb: cb
        )
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
