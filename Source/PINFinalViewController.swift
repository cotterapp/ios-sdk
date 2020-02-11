//
//  PINFinalViewController.swift
//  CotterIOS
//
//  Created by Albert Purnama on 2/3/20.
//

import LocalAuthentication
import Foundation

class PINFinalViewController: UIViewController {
    // MARK: - Keys for Strings
    static let closeTitle = "PINFinalViewController/closeTitle"
    static let closeMessage = "PINFinalViewController/closeMessage"
    static let stayOnView = "PINFinalViewController/stayOnView"
    static let leaveView = "PINFinalViewController/leaveView"
    
    // Alert Service
    let alertService = AlertService()
    let closeTitleText = CotterStrings.instance.getText(for: closeTitle)
    let closeMessageText = CotterStrings.instance.getText(for: closeMessage)
    let stayText = CotterStrings.instance.getText(for: stayOnView)
    let leaveText = CotterStrings.instance.getText(for: leaveView)
    
    // Auth Service
    let authService = LocalAuthService()
    
    // Config Variables
    var requireAuth = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Remove default Nav controller styling
        self.navigationItem.hidesBackButton = true
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layoutIfNeeded()
    }
    
    @IBAction func finish(_ sender: Any) {
        guard let onFinishCallback = Config.instance.callbackFunc else { return }
      
        // set access token or return values here
        // onFinishCallback("this is token")
        
        if requireAuth {
            // Touch ID/Face ID Verification
            authService.authenticate(view: self, reason: "Verifikasi", callback: onFinishCallback)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
