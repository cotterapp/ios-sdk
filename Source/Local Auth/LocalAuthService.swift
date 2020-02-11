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
    let authAction = "Gunakan PIN"
    
    let successAuthTitle = "Verifikasi"
    let successAuthMsg = "Biometric sesuai"
    let successCancel = "Batalkan"
    let successAction = "Input PIN"
    
    let failAuthTitle = "Authentication Failed"
    let failAuthMsg = "You could not be verified; please try again."
    let noAuthMsg = "Your device is not configured for biometric authentication"
    let tryAgain = "Coba Lagi"
    
    var successAuthCallbackFunc: ((String) -> Void)?
    
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
    
    private func biometricPubKeyRegistration(pubKey: SecKey) {
        // create base64 representation of the pubKey
        var error: Unmanaged<CFError>?
        guard let data = SecKeyCopyExternalRepresentation(pubKey, &error)! as Data? else {
            print(error!.takeRetainedValue().localizedDescription)
//                throw error!.takeRetainedValue() as Error
            return
        }
        let pubKeyBase64 = data.base64EncodedString()
        print("pubKey base64string sent: \(pubKeyBase64)")
        
        // Send the public key to the main server
        CotterAPIService.shared.http(
            method: "PUT",
            path: "/user/"+CotterAPIService.shared.userID!,
            data: [
                "method": "BIOMETRIC",
                "enrolled": true,
                "code": pubKeyBase64,
            ]
        )
    }
    
    public func pinAuth() throws -> Bool {
        let apiclient = CotterAPIService.shared
        
        guard let pubKey = KeyGen.pubKey else {
            throw CotterError.auth("unable to retrieve pubKey")
        }
        
        let ipAddr = LocalAuthService.ipAddr
        
        // TODO: send pubkey to the API
        
        return false
    }
    
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
            let biometricAlert = self.alertService.createDefaultAlert(
                title: "Verifikasi",
                body: "Lanjutkan untuk menggunakan verifikasi menggunakan TouchID atau FaceID",
                actionText: "Lanjutkan",
                cancelText: "Gunakan PIN",
                actionHandler: {
                    // this will force biometric scan request
                    guard KeyGen.privKey != nil else {
                        self.dispatchResult(view: view, success: false, authError: nil)
                        return
                    }
                    
                    // get the public key, this will trigger the faceID
                    guard let pubKey = KeyGen.pubKey else {
                        // if pubkey is unretrievable, then there must be something wrong with the bio scan
                        // TODO: error handling:
                        self.dispatchResult(view: view, success: false, authError: nil)
                        return
                    }
                    
                    self.biometricPubKeyRegistration(pubKey: pubKey)
                    self.dispatchResult(view: view, success: true, authError: nil)
                },
                cancelHandler: {
                    self.dispatchResult(view: view, success: true, authError: nil)
                }
            )
            view.present(biometricAlert, animated:true)
        } else {
            // no biometric then skip creating the public key
            self.dispatchResult(view: view, success: true, authError: nil)
        }
    }
    
    private func dispatchResult(view: UIViewController?, success: Bool, authError: Error?) {
        if success {
            print("Successful local authentication!")
            // Give Success Alert
            let successAlert = self.alertService.createDefaultAlert(
                title: self.successAuthTitle,
                body: self.successAuthMsg,
                actionText: self.authAction,
                cancelText: self.authCancel
            )
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
                cancelText: self.authAction,
                actionHandler: tryAgain,
                cancelHandler: {
                    failedBiometricAlert?.dismiss(animated:true)
                    self.successAuthCallbackFunc?("Token from failed biometric")
                }
            )
            view?.present(failedBiometricAlert!, animated: true)
            // TODO: Allow user to Input PIN instead?
        }
    }
}
