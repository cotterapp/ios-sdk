//
//  LocalAuthService.swift
//  CotterIOS
//
//  Created by Raymond Andrie on 2/4/20.
//

import Foundation
import UIKit
import os.log
import LocalAuthentication

class LocalAuthService: UIViewController {
    public static var ipAddr: String?

    // setIPAddr should run on initializing the Cotter's root controller
    public static func setIPAddr() {
        // all you need to do is
        // curl 'https://api.ipify.org?format=text'
        let url = URL(string: "https://api.ipify.org?format=text")!

        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data else { return }
            LocalAuthService.ipAddr = String(data: data, encoding: .utf8)!
        }
        task.resume()
        return
    }
    
    // pinAuth should authenticate the pin
    public func pinAuth(
        pin: String,
        event: String,
        callback: @escaping ((Bool, CotterError?) -> Void)
    ) throws -> Bool {
        let apiclient = CotterAPIService.shared
        
        let userID = apiclient.cotterUserID
        if userID == "" {
            os_log("%{public}@ user id is not provided",
                   log: Config.instance.log, type: .error,
                   #function)
            return false
        }
        
        func httpCb(response: CotterResult<CotterEvent>) {
            switch response {
            case .success(let resp):
                callback(resp.approved, nil)
            case .failure(let err):
                // we can handle multiple error results here
                callback(false, err)
            }
        }
        
        CotterAPIService.shared.auth(
            userID:userID,
            issuer:apiclient.apiKeyID,
            event:event,
            code:pin,
            method:CotterMethods.Pin,
            cb: httpCb
        )
        
        return true
    }
}
