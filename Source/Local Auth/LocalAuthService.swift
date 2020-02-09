//
//  LocalAuthService.swift
//  CotterIOS
//
//  Created by Raymond Andrie on 2/4/20.
//

import Foundation
import LocalAuthentication

class LocalAuthService {
    
    // Alert Service
    let alertService = AlertService()
    
    // Configs
    let authTitle = "Verifikasi"
    let authBody = "Sentuh sensor sidikjari untuk melanjutkan"
    let authCancel = "Batalkan"
    let authAction = "Input PIN"
    
    let successAuthTitle = "Verifikasi"
    let successAuthMsg = "Sidik jari sesual"
    let successCancel = "Batalkan"
    let successAction = "Input PIN"
    
    let failAuthTitle = "Authentication Failed"
    let failAuthMsg = "You could not be verified; please try again."
    let noAuthMsg = "Your device is not configured for biometric authentication"
    let tryAgain = "Coba Lagi"
    
    var successAuthCallbackFunc: ((String) -> Void)?
    
    // Configure Local Authentication
    public func authenticate(
        view: UIViewController,
        reason: String,
        callback: ((String) -> Void)?
    ) {
        successAuthCallbackFunc = callback
        
        let context = LAContext()
        var error: NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            // get the public key, this will trigger the faceID
            guard let pubKey = KeyGen.pubKey else {
                // if pubkey is unretrievable, then there must be something wrong with the bio scan
                // TODO: error handling:
                self.dispatchResult(view: view, success: false, authError: nil)
                return
            }
            
            // create base64 representation of the pubKey
            let publicKeyNSData = NSData(data: pubKey as! Data)
            let pubKeyBase64 = publicKeyNSData.base64EncodedString()
            print("pubKey base64string sent: \(pubKeyBase64)")
            
            // Send the public key to the main server
            CotterAPIService.shared.http(
                method: "PUT",
                path: "/user/"+CotterAPIService.shared.getUserID()!,
                data: [
                    "method": "BIOMETRIC",
                    "enrolled": true,
                    "code": pubKeyBase64,
                ]
            )
            
        } else {
            // no biometric then skip creating the public key
            self.dispatchResult(view: view, success: true, authError: nil)
        }
    }
    
    private func dispatchResult(view: UIViewController?, success: Bool, authError: Error?) {
        if success {
            print("Successful local authentication!")
            // Give Success Alert
            let successAlert = self.alertService.createDefaultAlert(title: self.successAuthTitle, body: self.successAuthMsg, actionText: self.authAction, cancelText: self.authCancel)
            view?.present(successAlert, animated: true)
            // Dismiss Alert after 3 seconds, then run callback
            let timer = DispatchTime.now() + 3
            DispatchQueue.main.asyncAfter(deadline: timer) {
                successAlert.dismiss(animated: true) {
                    // Run callback
                    self.successAuthCallbackFunc?("This is token!")
                }
            }
        } else {
            // Give Failed Authentication Alert
            print("Failed local authentication!")
            
            var failedBiometricAlert: UIAlertController?

            // try again will re-authenticate
            func tryAgain(){
                guard let alert = failedBiometricAlert else {
                    LocalAuthService().authenticate(view: view!, reason: "", callback: successAuthCallbackFunc)
                    return
                }
                alert.dismiss(animated: true)
                LocalAuthService().authenticate(view: view!, reason: "", callback: successAuthCallbackFunc)
            }
            failedBiometricAlert = self.alertService.createDefaultAlert(
                title: self.authTitle,
                body: self.failAuthMsg,
                actionText: self.tryAgain,
                cancelText: self.successAction,
                actionHandler: tryAgain
            )
            view?.present(failedBiometricAlert!, animated: true)
            // TODO: Allow user to Input PIN instead?
        }
    }
}
