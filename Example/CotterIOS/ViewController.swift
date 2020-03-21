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
    
    let userID:String = randomString(length: 5)
    override func viewWillAppear(_ animated: Bool) {
        errorLabel.text = ""
        self.setupBiometricToggle()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // to set the apiKeyID and apiSecretKey follow this nice tutorial on how to setup xcode env variables
        // https://nshipster.com/launch-arguments-and-environment-variables/
        guard let apiKeyID = ProcessInfo.processInfo.environment["COTTER_API_KEY_ID"] else {
            print("please set COTTER_API_KEY_ID in your XCode environment variables!")
            return
        }
        guard let apiSecretKey = ProcessInfo.processInfo.environment["COTTER_API_SECRET_KEY"] else {
            print("please set COTTER_API_SECRET_KEY in your XCode environment variables!")
            return
        }
        
        // set the URL path
        var baseURL = "https://www.cotter.app/api/v0"
        if let devMode = ProcessInfo.processInfo.environment["DEV_MODE"] {
            switch(devMode){
            case "ios":
                baseURL = "http://192.168.1.9:1234/api/v0"
                break
            case "local":
                baseURL = "http://localhost:1234/api/v0"
                break
            default:
                break
            }
        }
        
        // select the dashboard's ViewController
        let sboard = UIStoryboard(name: "Dashboard", bundle: nil)
        let dVC = sboard.instantiateViewController(withIdentifier: "DashboardViewController") as! DashboardViewController
        
        func cbFunc(accessToken: String, error: Error?) -> Void{
            guard let error = error else {
                dVC.accessToken = accessToken
                self.navigationController?.pushViewController(dVC, animated: true)
                return
            }
          
            // error handling
            self.errorLabel.text = error.localizedDescription
        }
        
        Callback.shared.authCb = cbFunc
        
        // langConfig is an optional language configuration
        let langConfig = Indonesian()
        
        // if you want to set text configuration uncomment the following
        // langConfig.setText(for: PINViewControllerKey.title, to: "Hi! You've changed the text")
        
        // if you want to set image configuration, uncomment the following and put the image in Images.xcassets folder
//        let imageConfig = ImageObject()
//        imageConfig.setImage(for: VCImageKey.pinSuccessImg, to: "telegram")
        
        /*
         Available Color Scheme options:
            1. primary (type: UIColor?/Int?/String?) - default: #21CE99
            2. accent (type: UIColor?/Int?/String?) - default: #21CE99
            3. danger (type: UIColor?/Int?/String?) - default: #D92C59
         let colorScheme = ColorSchemeObject(primary: primary, accent: accent, danger: danger)
            OR
         colorScheme.primary = UIColor.color
         colorScheme.accent = UIColor(rgb: String/Int)
        */
        
        // Uncomment the following to set the colors to something different
        // let colorScheme = ColorSchemeObject(primary: "#355C7D", accent: "#6C5B7B", danger: "#F67280")
        
        /* User Info Configuration: To enable Reset PIN Process in Transaction Flow, required to pass in name, sending method, etc. for Reset PIN Process */
        let userName = "Albert"
        let sendingMethod = "EMAIL" // or PHONE
        let sendingDestination = "bioshocked2@gmail.com" // Set user email here
        
        // Load Cotter View Controller from SDK
        CotterWrapper.cotter = Cotter(
            apiSecretKey: apiSecretKey,
            apiKeyID: apiKeyID,
            cotterURL: baseURL,
            userID: self.userID,
            // configuration is an optional argument, remove this below and Cotter app will still function properly
            configuration: [
                "language": langConfig,   // default value is Indonesian()
                "name": userName,
                "sendingMethod": sendingMethod, // or PHONE
                "sendingDestination": sendingDestination,
                // "colors": colorScheme
            ]
        )
        
        CotterWrapper.cotter!.clearKeys()
        
        // check the if the userID can be set
        CotterWrapper.cotter!.userID = self.userID
        
        // you can also set texts after initialization
        // CotterWrapper.cotter?.setText(key: PINViewController.title, value: "Hello World!")
        
        // set the base URL for PLBaseURL FOR DEVELOPMENT ONLY!
        Cotter.PLBaseURL = "http://localhost:3000/app"
        
        func registerUserCb(_ response: CotterResult<CotterUser>){
            switch response{
            case .success(let user):
                print("successfully registered: \(user.enrolled)")
                self.setup()
                
            case .failure(let err):
                // you can put exhaustive error handling here
                switch err{
                case CotterAPIError.decoding:
                    print("this is decoding error on registering user")
                    break
                case CotterAPIError.network:
                    print("this is network error on registering user")
                    break
                case CotterAPIError.status:
                    print("this is not successful error")
                    break
                default:
                    print("error registering user: \(err)")
                }
            }
        }
        
        CotterAPIService.shared.registerUser(
            userID: self.userID,
            cb: registerUserCb
        )
    }
    
    func setup() {
        self.setupBiometricToggle()
        self.setupTrustedDevice()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func clickCotter(_ sender: Any) {
        // CotterWrapper.cotter?.startEnrollment(animated: true)
        
        // to optionally hide the close button
        CotterWrapper.cotter?.startEnrollment(vc: self, animated: true, cb: Callback.shared.authCb, hideClose:true)
    }
    
    @IBAction func clickStartTransaction(_ sender: Any) {
        CotterWrapper.cotter?.startTransaction(vc: self, animated: true, cb: Callback.shared.authCb)
        
        // to optionally hide the back button
        // CotterWrapper.cotter?.startTransaction(animated: true, hideClose:true)
    }
    
    @IBAction func clickUpdateProfile(_ sender: Any) {
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
        case "segueToTrustedDevice":
            print("prepare segue for TrustedDeviceViewController")
            let vc = segue.destination as! TrustedDeviceViewController
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
                let lookFor = CotterConstants.MethodBiometric
                var biometricAvailable = false
                for method in resp.enrolled {
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

func randomString(length: Int) -> String {
  let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
  return String((0..<length).map{ _ in letters.randomElement()! })
}
