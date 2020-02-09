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
    // Enrollment Path
    var cotter: CotterViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        // set the URL path
        let baseURL = "https://cotter.app"
        let urlString = "https://www.cotter.app/api/v0/user/create"
        let clientUserID = randomString(length: 5)
        
        // Comment out
        let apiSecretKey = "K3yoIkKY2FpiLX7YWEff"
        let apiKeyID = "26260f9e-3db1-4bef-b3fd-d0310eff1c7f"


        let url = URL(string: urlString)!
        
        var request = URLRequest(url:url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(apiSecretKey, forHTTPHeaderField: "API_SECRET_KEY")
        request.setValue(apiKeyID, forHTTPHeaderField: "API_KEY_ID")
        request.httpMethod = "POST"
        let parameters: [String: Any] = [
            "client_user_id": clientUserID
        ]
        let jsonData = try? JSONSerialization.data(withJSONObject: parameters)
        let jsonString = String(data: jsonData!, encoding: .utf8)
        print(jsonString as Any)
        request.httpBody = jsonData


        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            guard let data = data,
                let response = response as? HTTPURLResponse,
                error == nil else { // check for fundamental networking error
                // TODO: error handling
                print("error", error ?? "Unknown error")
                return
            }

            guard (200 ... 299) ~= response.statusCode else {   // check for http errors
                print("statusCode should be 2xx, but is \(response.statusCode)")
                print("response = \(response)")
                return
            }

            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
        }
        task.resume()
        
        // select the dashboard's ViewController
        let sboard = UIStoryboard(name: "Dashboard", bundle: nil)
        let dVC = sboard.instantiateViewController(withIdentifier: "DashboardViewController") as! DashboardViewController
        
        func cbFunc(accessToken:String) -> Void{
            self.navigationController?.popToViewController(self, animated: false)
            dVC.accessToken = accessToken
            self.navigationController?.pushViewController(dVC, animated: true)
        }
        
        // Load Cotter View Controller from SDK
        self.cotter = CotterViewController.init(
            cbFunc,
            apiSecretKey,
            apiKeyID,
            baseURL,
            clientUserID
        )
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func clickCotter(_ sender: Any) {
        self.cotter?.startEnrollment(parentNav: self.navigationController!, animated: true)
    }
    
    @IBAction func clickStartTransaction(_ sender: Any) {
        self.cotter?.startTransaction(parentNav: self.navigationController!, animated: true)
    }
    
    @IBAction func clickUpdateProfile(_ sender: Any) {
        self.cotter?.startUpdateProfile(parentNav: self.navigationController!, animated: true)
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
