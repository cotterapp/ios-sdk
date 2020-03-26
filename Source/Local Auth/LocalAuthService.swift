//
//  LocalAuthService.swift
//  CotterIOS
//
//  Created by Raymond Andrie on 2/4/20.
//

import Foundation
import LocalAuthentication

class LAlertDelegate: AlertServiceDelegate {
    var defActionHandler = {
        print("LAlertDelegate default action handler")
        return
    }
    var defCancelHandler = {
        print("LAlertDelegate default cancel handler")
        return
    }
    
    func actionHandler() {
        print("action")
        defActionHandler()
        return
    }
    
    func cancelHandler() {
        print("cancel")
        defCancelHandler()
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
    
    var successAuthCallbackFunc: FinalAuthCallback?
    
    public static var ipAddr: String?
    
    // default alert delegate
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
        
        guard let userID = CotterAPIService.shared.userID else { return }
        
        // Send the public key to the main server
        CotterAPIService.shared.registerBiometric(userID:userID, pubKey:pubKeyBase64, cb:DefaultResultCallback)
    }
    
    // pinAuth should authenticate the pin
    public func pinAuth(
        pin: String,
        event: String,
        callback: @escaping ((Bool) -> Void)
    ) throws -> Bool {
        let apiclient = CotterAPIService.shared
        
        guard let userID = apiclient.userID else {
            return false
        }
        print("userID: \(userID)")
        
        func httpCb(response: CotterResult<CotterEvent>) {
            switch response {
            case .success(let resp):
                callback(resp.approved)
            case .failure(let err):
                // we can handle multiple error results here
                print(err.localizedDescription)
            }
        }
        
        print("PIN: \(pin)")
        
        CotterAPIService.shared.auth(
            userID:userID,
            issuer:apiclient.apiKeyID,
            event:event,
            code:pin,
            method:"PIN",
            cb: httpCb
        )
        
        return true
    }
    
    // auth does not register the public key to the server when the user is authenticated
    // Used for Biometric Authentication Challenge
    public func bioAuth(
        view: UIViewController,
        event: String,
        callback: @escaping ((Bool) -> Void)
    ) {
        let context = LAContext()
        var error: NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let aService = AlertService(
                vc: view,
                title: verifyAuthTitle,
                body: verifyAuthBody,
                actionButtonTitle: verifyAuthAction,
                cancelButtonTitle: verifyAuthCancel,
                imagePath: fingerprintImg
            )
            
            alertDelegate.defActionHandler = {
                aService.hide()
                // this will force biometric scan request
                guard let privateKey = KeyStore.biometric.privKey else {
                    self.dispatchResult(view: view, success: false, authError: nil)
                    return
                }

                // get the public key, this will trigger the faceID
                guard let pubKey = KeyStore.biometric.pubKey else {
                    // if pubkey is unretrievable, then there must be something wrong with the bio scan
                    // TODO: error handling:
                    self.dispatchResult(view: view, success: false, authError: nil)
                    return
                }

                let b64PubKey = CryptoUtil.keyToBase64(pubKey: pubKey)
                
                let cl = CotterAPIService.shared
                let issuer = cl.apiKeyID
                guard let userID = cl.userID else {
                    print("user id not set")
                    return
                }
                let timestamp = String(format:"%.0f",NSDate().timeIntervalSince1970.rounded())
                let evtMethod = "BIOMETRIC"
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
                    print("failed to create signature")
                    return
                }

                let strSignature = signature.base64EncodedString()
                

                func httpCb(response: CotterResult<CotterEvent>) {
                    switch response {
                    case .success(let resp):
                        callback(resp.approved)
                    case .failure(let err):
                        // we can handle multiple error results here
                        print(err.localizedDescription)
                    }
                }
                
                CotterAPIService.shared.auth(
                    userID:userID,
                    issuer:issuer,
                    event:event,
                    code:strSignature,
                    method:"BIOMETRIC",
                    pubKey: b64PubKey, // optional
                    timestamp: timestamp, // optional
                    cb: httpCb
                )

            }
            
            alertDelegate.defCancelHandler = {
                aService.hide()
            }
            
            aService.delegate = alertDelegate
            aService.show()
        } else {
            // no biometric then do nothing
            print("No Biometrics Available!")
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
            let aService = AlertService(
                vc: view,
                title: enrollAuthTitle,
                body: enrollAuthBody,
                actionButtonTitle: enrollAuthAction,
                cancelButtonTitle: enrollAuthCancel,
                imagePath: fingerprintImg
            )
            let delegate = LAlertDelegate()
            delegate.defActionHandler = {
                print("got here")
                aService.hide()
                // this will force biometric scan request
                guard KeyStore.biometric.privKey != nil else {
                    self.dispatchResult(view: view, success: false, authError: nil)
                    return
                }

                // get the public key, this will trigger the faceID
                guard let pubKey = KeyStore.biometric.pubKey else {
                    // if pubkey is unretrievable, then there must be something wrong with the bio scan
                    // TODO: error handling:
                    self.dispatchResult(view: view, success: false, authError: nil)
                    return
                }

                self.biometricPubKeyRegistration(pubKey: pubKey)
                self.dispatchResult(view: view, success: true, authError: nil)
            }

            delegate.defCancelHandler =  {
                print("defCancelHandler")
                aService.hide()
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
        guard let view = view else { return }
        
        if success {
            print("Successful local authentication!")
            
            // Give Success Alert
            let successAlert = AlertService(
                vc: view,
                title: self.successTitle,
                body: self.successBody,
                actionButtonTitle: self.successAction,
                cancelButtonTitle: self.successCancel,
                imagePath: successImg
            )
            
            let successAlertDelegate = LAlertDelegate()
            successAlert.delegate = successAlertDelegate
            successAlert.show()
            
            // Dismiss Alert after 3 seconds, then run callback
            let timer = DispatchTime.now() + 3
            DispatchQueue.main.asyncAfter(deadline: timer) {
                successAlert.hide(onComplete: { (finished: Bool) in
                    self.successAuthCallbackFunc?("This is token from dispatch!", nil)
                    return
                })
            }
        } else {
            // Give Failed Authentication Alert
            print("Failed local authentication!")
            
            let failedBiometricAlert = AlertService(
                vc: view,
                title: self.failureTitle,
                body: self.failureBody,
                actionButtonTitle: self.failureAction,
                cancelButtonTitle: self.failureCancel,
                imagePath: failureImg
            )
            
            // try again will re-authenticate
            func tryAgain(){
                failedBiometricAlert.hide(onComplete: {(finished:Bool) in
                    LocalAuthService().authenticate(view: view, reason: "", callback: self.successAuthCallbackFunc)
                })
            }
            
            let failedBiometricAlertDelegate = LAlertDelegate()
            failedBiometricAlertDelegate.defActionHandler = tryAgain
            failedBiometricAlertDelegate.defCancelHandler = {
                failedBiometricAlert.hide()
                
                // the PIN enrollment is still successful, but biometric registration failed
                self.successAuthCallbackFunc?("Token from failed biometric", nil)
            }
            
            failedBiometricAlert.delegate = failedBiometricAlertDelegate
            failedBiometricAlert.show()
        }
    }
}
