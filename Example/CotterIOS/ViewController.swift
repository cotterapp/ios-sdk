//
//  ViewController.swift
//  CotterIOS
//
//  Created by albertputrapurnama on 02/01/2020.
//  Copyright (c) 2020 albertputrapurnama. All rights reserved.
//

import UIKit
import Cotter
import Foundation

class ViewController: UIViewController {
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var bioSwitch: UISwitch!
    
    @IBOutlet weak var userInfoLabel: UILabel!
    
    var userID:String = ""
    
    override func viewWillAppear(_ animated: Bool) {
        errorLabel.text = ""
        userInfoLabel.text = Cotter.getLoggedInUserID()
        print("userInfoLabel", userInfoLabel.text)
        self.setupBiometricToggle()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // select the dashboard's ViewController
        let sboard = UIStoryboard(name: "Dashboard", bundle: nil)
        let dVC = sboard.instantiateViewController(withIdentifier: "DashboardViewController") as! DashboardViewController
        
        func cbFunc(accessToken: String, error: Error?) -> Void {
            print("hello world!")
            guard let error = error else {
                dVC.accessToken = accessToken
                print("[cbFunc] accessToken:", accessToken)
                self.navigationController?.pushViewController(dVC, animated: true)
                return
            }
          
            // error handling
            self.errorLabel.text = error.localizedDescription
        }
        
        Callback.shared.authCb = cbFunc
        
        self.setupBiometricToggle()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func clickCotter(_ sender: Any) {
        // CotterWrapper.cotter?.startEnrollment(animated: true)
        
        // to optionally hide the close button
        CotterWrapper.cotter?.startEnrollment(vc: self, animated: true, cb: Callback.shared.authCb)
    }
    
    @IBAction func clickStartTransaction(_ sender: Any) {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        CotterWrapper.cotter?.startTransaction(
            vc: self,
            animated: true,
            cb: Callback.shared.authCb,
            hideClose: true,
            name: "Albert", // fill the user's name
            sendingMethod: "EMAIL", // fill user's email
            sendingDestination: "albert@cotter.app"
        )
        
        // to optionally hide the back button
        // CotterWrapper.cotter?.startTransaction(animated: true, hideClose:true)
    }
    
    @IBAction func clickUpdateProfile(_ sender: Any) {
        // set the back button navigation
         self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        CotterWrapper.cotter?.startUpdateProfile(vc: self, animated: true, cb: Callback.shared.authCb)
    }

    @IBAction func goToUserCheck(_ sender: Any) {
        print("goToUserCheck")
        performSegue(withIdentifier: "segueToUserCheck", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        switch(identifier) {
        case "segueToUserCheck":
            print("prepare segue for UserCheckViewController")
            let vc = segue.destination as! UserCheckViewController
            vc.userID = self.userID
        default:
            print("unknown segue identifier: \(identifier)")
        }
    }
    
    @IBAction func switchBiometric(_ sender: Any) {
        func cb(response: CotterResult<CotterUser>) {
            print("Successfully updated Biometric enrollment")
            
            switch response {
            case .success(let resp):
                let lookFor = CotterMethods.Biometric
                var biometricAvailable = false
                for method in resp.enrolled ?? [] {
                    if method == lookFor {
                        biometricAvailable = true
                    }
                }
                self.bioSwitch.setOn(biometricAvailable, animated: true)
            case .failure(let err):
                // we can handle multiple error results here
                print(err.localizedDescription)
            }
        }
        CotterAPIService.shared.updateBiometricStatus(enrollBiometric: self.bioSwitch.isOn, cb: cb)
    }
    
    @IBAction func logout(_ sender: Any) {
        Cotter.logout()
        
        // your logout logic...
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func trustedDevice(_ sender: Any) {
        print("segueToTrustedDevice")
        performSegue(withIdentifier: "segueToTrustedDevice", sender: self)
    }
}

extension ViewController {
    // only call setupBiometricToggle when the user is successfully been registered
    // to the server
    private func setupBiometricToggle() {
        func cb(response: CotterResult<EnrolledMethods>) {
            switch response {
            case .success(let resp):
                let biometricAvailable = resp.enrolled
                
                self.bioSwitch.setOn(biometricAvailable, animated: true)
            case .failure(let err):
                // we can handle multiple error results here
                print(err.localizedDescription)
            }
        }
        CotterAPIService.shared.getBiometricStatus(cb: cb)
    }
}

// the following extensions is copied from
// https://stackoverflow.com/questions/26364914/http-request-in-swift-with-post-method
extension Dictionary {
    func percentEncoded() -> Data? {
        return map { key, value in
            let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            return escapedKey + "=" + escapedValue
        }
        .joined(separator: "&")
        .data(using: .utf8)
    }
}

extension CharacterSet {
    static let urlQueryValueAllowed: CharacterSet = {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="

        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        return allowed
    }()
}
