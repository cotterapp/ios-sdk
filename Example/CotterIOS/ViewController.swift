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

    override func viewDidLoad() {
        super.viewDidLoad()
        // set the URL path
        let baseURL = "https://www.cotter.app/api/v0"
        let clientUserID = randomString(length: 5)
        
        // select the dashboard's ViewController
        let sboard = UIStoryboard(name: "Dashboard", bundle: nil)
        let dVC = sboard.instantiateViewController(withIdentifier: "DashboardViewController") as! DashboardViewController
        
        func cbFunc(accessToken:String) -> Void{
            self.navigationController?.popToViewController(self, animated: false)
            dVC.accessToken = accessToken
            self.navigationController?.pushViewController(dVC, animated: true)
        }
        
        // Load Cotter View Controller from SDK
        CotterWrapper.cotter = Cotter.init(
            successCb: cbFunc,
            apiSecretKey: apiSecretKey,
            apiKeyID: apiKeyID,
            cotterURL: baseURL,
            userID: clientUserID,
            // configuration is an optional argument, remove this below and Cotter app will still function properly
            configuration: [
                "language": "English"   // default value is "Indonesian"
            ]
        )
        
        // set the base URL for PLBaseURL FOR DEVELOPMENT ONLY!
        Cotter.PLBaseURL = "http://localhost:3000/app"
        
        CotterAPIService.shared.registerUser(
            userID: clientUserID,
            successCb: defaultCb,
            errCb: defaultCb
        )
        
        print(String(format:"%f", Date().timeIntervalSince1970.rounded()))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func clickCotter(_ sender: Any) {
        CotterWrapper.cotter?.startEnrollment(parentNav: self.navigationController!, animated: true)
    }
    
    @IBAction func clickStartTransaction(_ sender: Any) {
        CotterWrapper.cotter?.startTransaction(parentNav: self.navigationController!, animated: true)
    }
    
    @IBAction func clickUpdateProfile(_ sender: Any) {
        CotterWrapper.cotter?.startUpdateProfile(parentNav: self.navigationController!, animated: true)
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
