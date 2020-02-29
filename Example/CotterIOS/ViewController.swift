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
    
    var userID:String = ""
    override func viewWillAppear(_ animated: Bool) {
        errorLabel.text = ""
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
        self.userID = randomString(length: 5)
        
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
        
        // langConfig is an optional language configuration
        let langConfig = Indonesian()
        
        // if you want to set text configuration uncomment the following
        // langConfig.setText(for: PINViewControllerKey.title, to: "Hi! You've changed the text")
        // if you want to set success image configuration uncomment the following
        // langConfig.setText(for: PINFinalViewControllerKey.successImage, to: "telegram")
        
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
        
        // Load Cotter View Controller from SDK
        CotterWrapper.cotter = Cotter(
            from: self,
            apiSecretKey: apiSecretKey,
            apiKeyID: apiKeyID,
            cotterURL: baseURL,
            userID: self.userID,
            onComplete: cbFunc,
            // configuration is an optional argument, remove this below and Cotter app will still function properly
            configuration: [
                "language": langConfig,   // default value is Indonesian()
                // "colors": colorScheme
            ]
        )
        
        // you can also set texts after initialization
        // CotterWrapper.cotter?.setText(key: PINViewController.title, value: "Hello World!")
        
        // set the base URL for PLBaseURL FOR DEVELOPMENT ONLY!
        Cotter.PLBaseURL = "http://localhost:3000/app"
        
        CotterAPIService.shared.registerUser(
            userID: self.userID,
            cb: DefaultCallback()
        )
        
        print(String(format:"%f", Date().timeIntervalSince1970.rounded()))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func clickCotter(_ sender: Any) {
        CotterWrapper.cotter?.startEnrollment(animated: true)
    }
    
    @IBAction func clickStartTransaction(_ sender: Any) {
        CotterWrapper.cotter?.startTransaction(animated: true)
    }
    
    @IBAction func clickUpdateProfile(_ sender: Any) {
        CotterWrapper.cotter?.startUpdateProfile(animated: true)
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
            break
        default:
            print("unknown segue identifier: \(identifier)")
            break
        }
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
