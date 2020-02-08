//
//  PINFinalViewController.swift
//  CotterIOS
//
//  Created by Albert Purnama on 2/3/20.
//

import LocalAuthentication
import Foundation

class PINFinalViewController: UIViewController {
    public var config: Config?
    
    // Alert Service
    let alertService = AlertService()
    let closeTitle = "Verifikasi"
    let closeMessage = "Sentuh sensor sidik jari untuk melanjutkan"
    let stayText = "Input PIN"
    let leaveText = "Batalkan"
    
    // Auth Service
    let authService = LocalAuthService()
    
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
//        // set access token or return values here
//        self.config?.callbackFunc!("this is token")
        
        // Touch ID/Face ID Verification
        authService.authenticate(view: self, reason: "Verifikasi", callback: self.config?.callbackFunc)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
