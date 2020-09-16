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

class LAlertDelegate: AlertServiceDelegate, BottomPopupModalDelegate {
    var defActionHandler = {
        return
    }
    var defCancelHandler = {
        return
    }
    var defDismissCompletion = {
        return
    }
    
    @objc func actionHandler() {
        defActionHandler()
        return
    }
    
    @objc func cancelHandler() {
        defCancelHandler()
        return
    }
    
    @objc func dismissCompletion() {
        defDismissCompletion()
        return
    }
}

class LocalAuthService: UIViewController {
    
    // MARK: - Alert Text Definitions
    let enrollAuthTitle = CotterStrings.instance.getText(for: AuthAlertMessagesKey.enrollAuthTitle)
    let enrollAuthBody = CotterStrings.instance.getText(for: AuthAlertMessagesKey.enrollAuthBody)
    let enrollAuthAction = CotterStrings.instance.getText(for: AuthAlertMessagesKey.enrollAuthActionButton)
    let enrollAuthCancel = CotterStrings.instance.getText(for: AuthAlertMessagesKey.enrollAuthCancelButton)
    
    let verifyAuthTitle = CotterStrings.instance.getText(for: AuthAlertMessagesKey.verifyAuthTitle)
    let verifyAuthBody = CotterStrings.instance.getText(for: AuthAlertMessagesKey.verifyAuthBody)
    let verifyAuthAction = CotterStrings.instance.getText(for: AuthAlertMessagesKey.verifyAuthActionButton)
    let verifyAuthCancel = CotterStrings.instance.getText(for: AuthAlertMessagesKey.verifyAuthCancelButton)
    
    let successTitle = CotterStrings.instance.getText(for: AuthAlertMessagesKey.successDispatchTitle)
    let successBody = CotterStrings.instance.getText(for: AuthAlertMessagesKey.successDispatchBody)
    let successAction = CotterStrings.instance.getText(for: AuthAlertMessagesKey.successDispatchActionButton)
    let successCancel = CotterStrings.instance.getText(for: AuthAlertMessagesKey.successDispatchCancelButton)
    
    let failureTitle = CotterStrings.instance.getText(for: AuthAlertMessagesKey.failureDispatchTitle)
    let failureBody = CotterStrings.instance.getText(for: AuthAlertMessagesKey.failureDispatchBody)
    let failureAction = CotterStrings.instance.getText(for: AuthAlertMessagesKey.failureDispatchActionButton)
    let failureCancel = CotterStrings.instance.getText(for: AuthAlertMessagesKey.failureDispatchCancelButton)
    
    // MARK: - Image Path Definitions
    let fingerprintImg = CotterImages.instance.getImage(for: AlertImageKey.promptVerificationImg)
    let successImg = CotterImages.instance.getImage(for: AlertImageKey.successVerificationImg)
    let failureImg = CotterImages.instance.getImage(for: AlertImageKey.failureVerificationImg)
    let bioFailImg = CotterImages.instance.getImage(for: AlertImageKey.failureBiometricImg)
    
    var successAuthCallbackFunc: FinalAuthCallback?
    
    public static var ipAddr: String?
    
    // default bottom popup delegate
    let alertDelegate = LAlertDelegate()

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
        let pubKeyBase64 = CryptoUtil.keyToBase64(pubKey: pubKey)
        
        let userID = CotterAPIService.shared.cotterUserID
        
        // Send the public key to the main server
        CotterAPIService.shared.registerBiometric(userID:userID, pubKey:pubKeyBase64, cb:DefaultResultCallback)
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
    
    // auth does not register the public key to the server when the user is authenticated
    // Used for Biometric Authentication Challenge
    public func bioAuth(
        view: UIViewController,
        event: String,
        callback: @escaping ((Bool, CotterError?) -> Void)
    ) {
        let context = LAContext()
        var error: NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let bottomPopupScanPrompt = BottomPopupModal(
                img: getUIImage(imagePath: fingerprintImg),
                title: verifyAuthTitle,
                body: verifyAuthBody,
                actionText: verifyAuthAction,
                cancelText: verifyAuthCancel
            )
            
            alertDelegate.defActionHandler = {
                os_log("defActionHandler",log: Config.instance.log, type: .debug)
                LoadingScreen.shared.start(at: self.view.window)
                bottomPopupScanPrompt.dismiss(animated: false)
                
                guard let privateKey = KeyStore.biometric.privKey else {
                    self.dispatchResult(view: view, success: false, authError: nil)
                    return
                }
                
                // TODO: should derive pubKey from privateKey
                guard let pubKey = KeyStore.biometric.pubKey else {
                    self.dispatchResult(view: view, success: false, authError: CotterError.biometricVerification)
                    return
                }
                
                let b64PubKey = CryptoUtil.keyToBase64(pubKey: pubKey)
                
                let cl = CotterAPIService.shared
                let issuer = cl.apiKeyID
                let userID = cl.cotterUserID
                if userID == "" {
                    os_log("%{public}@ user id is not provided",
                           log: Config.instance.log, type: .error,
                           #function)
                    return
                }
                
                let timestamp = String(format:"%.0f",NSDate().timeIntervalSince1970.rounded())
                let evtMethod = CotterMethods.Biometric
                let approved = "true"
                
                let strToBeSigned = userID + issuer + event + timestamp + evtMethod + approved
                let data = strToBeSigned.data(using: .utf8)! as CFData

                // set the signature algorithm
                let algorithm: SecKeyAlgorithm = .ecdsaSignatureMessageX962SHA256
                
                var error: Unmanaged<CFError>?
                // create a signature
                guard let signature = SecKeyCreateSignature(
                    privateKey,
                    algorithm,
                    data as CFData,
                    &error
                ) as Data? else {
                    os_log("%{public}@ failed to create signature",
                           log: Config.instance.log, type: .error,
                           #function)
                    return
                }

                let strSignature = signature.base64EncodedString()
                
                func httpCb(response: CotterResult<CotterEvent>) {
                    switch response {
                    case .success(let resp):
                        LoadingScreen.shared.stop()
                        callback(resp.approved, nil)
                    case .failure(let err):
                        LoadingScreen.shared.stop()
                        callback(false, err)
                    }
                }
                
                CotterAPIService.shared.auth(
                    userID:userID,
                    issuer:issuer,
                    event:event,
                    code:strSignature,
                    method: CotterMethods.Biometric,
                    pubKey: b64PubKey, // optional
                    timestamp: timestamp, // optional
                    cb: httpCb
                )

            }
            
            alertDelegate.defCancelHandler = {
                bottomPopupScanPrompt.dismiss(animated: false)
            }
            
            bottomPopupScanPrompt.delegate = alertDelegate
            bottomPopupScanPrompt.show()
            
        } else {
            // no biometric then do nothing
            os_log("%{public}@ biometric not available",
                   log: Config.instance.log, type: .debug,
                   #function)
        }
    }
    
    // Configure Local Authentication
    // Used for PIN Enrollment
    public func authenticate(
        view: UIViewController,
        reason: String,
        callback: FinalAuthCallback?
    ) {
        successAuthCallbackFunc = callback
        
        let context = LAContext()
        var error: NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let aService = BottomPopupModal(
                img: getUIImage(imagePath: fingerprintImg),
                title: enrollAuthTitle,
                body: enrollAuthBody,
                actionText: enrollAuthAction,
                cancelText: enrollAuthCancel
            )
            let delegate = LAlertDelegate()
            delegate.defActionHandler = {
                aService.dismiss(animated: false)
                // this will force biometric scan request
                guard KeyStore.biometric.privKey != nil else {
                    self.dispatchResult(view: view, success: false, authError: nil)
                    return
                }

                // get the public key, this will trigger the faceID
                guard let pubKey = KeyStore.biometric.pubKey else {
                    // if pubkey is unretrievable, then there must be something wrong with the bio scan
                    // TODO: error handling:
                    self.dispatchResult(view: view, success: false, authError: CotterError.biometricEnrollment)
                    return
                }

                self.biometricPubKeyRegistration(pubKey: pubKey)
                self.dispatchResult(view: view, success: true, authError: nil)
            }

            delegate.defCancelHandler =  {
                aService.dismiss(animated: false)
                self.dispatchResult(view: view, success: true, authError: nil)
            }
            aService.delegate = delegate
            aService.show()
        } else {
            // no biometric then skip creating the public key
            successAuthCallbackFunc?("token", nil)
        }
    }
    
    private func dispatchResult(view: UIViewController?, success: Bool, authError: Error?) {
        // stop loading screen
        LoadingScreen.shared.stop()
        
        guard let view = view else { return }
        
        if success {
            // Give Success Alert
            let successAlert = BottomPopupModal(
                img: getUIImage(imagePath: successImg),
                title: self.successTitle,
                body: self.successBody,
                actionText: self.successAction,
                cancelText: self.successCancel
            )
            
            let successAlertDelegate = LAlertDelegate()
            successAlertDelegate.defDismissCompletion = {
                self.successAuthCallbackFunc?("This is token from dispatch!", nil)
                return
            }
            successAlert.delegate = successAlertDelegate
            successAlert.show()
            
            // Dismiss Alert after 3 seconds, then run callback
            let timer = DispatchTime.now() + 3
            DispatchQueue.main.asyncAfter(deadline: timer) {
                successAlert.dismiss(animated: false)
            }
        } else {
            // Give Failed Authentication Alert
            os_log("%{public}@ biometric authentication failed",
                   log: Config.instance.log, type: .debug,
                   #function)
            
            let failedBiometricAlert = BottomPopupModal(
                img: getUIImage(imagePath: bioFailImg),
                title: self.failureTitle,
                body: self.failureBody,
                actionText: self.failureAction,
                cancelText: self.failureCancel
            )
            
            let failedBiometricAlertDelegate = LAlertDelegate()
            failedBiometricAlertDelegate.defActionHandler = {
                failedBiometricAlert.dismiss(animated: false)
                LocalAuthService().authenticate(view: view, reason: "", callback: self.successAuthCallbackFunc)
            }
            failedBiometricAlertDelegate.defCancelHandler = {
                failedBiometricAlert.dismiss(animated: false)
                
                // the PIN enrollment is still successful, but biometric registration failed
                self.successAuthCallbackFunc?("Token from failed biometric", authError)
            }
            
            failedBiometricAlert.delegate = failedBiometricAlertDelegate
            failedBiometricAlert.show()
        }
    }
}
