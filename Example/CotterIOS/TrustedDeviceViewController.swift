//
//  TrustedDeviceViewController.swift
//  CotterIOS_Example
//
//  Created by Albert Purnama on 3/20/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import Cotter

let baseURL = "https://www.cotter.app/api/v0"

class TrustedDeviceViewController: UIViewController {
    
    var userID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")

        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false

        view.addGestureRecognizer(tap)
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
        
        CotterWrapper.cotter?.getEventTrustedDevice(vc: self, cb: Callback.shared.authCb)
    }
    
    @IBAction func loginTrusted(_ sender: Any) {
        guard let userID = self.userIDTextField.text else { return }

        CotterWrapper.cotter?.loginWithTrustedDevice(vc: self, cb: Callback.shared.authCb)
    }
    
    @IBAction func registerDevice(_ sender: Any) {
        guard let userID = self.userIDTextField.text else { return }
        
        CotterWrapper.cotter?.registerNewDevice(vc: self, cb: Callback.shared.authCb)
    }
    
    @IBAction func scanNewDevice(_ sender: Any) {
        func callback(token:String, err: Error?) {
            if err != nil {
                self.textLabel.text = err?.localizedDescription
                return
            }
            self.textLabel.text = "Successfully registered new device"
        }
        
        CotterWrapper.cotter?.scanNewDevice(vc: self, cb: callback)
    }

    //Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
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
