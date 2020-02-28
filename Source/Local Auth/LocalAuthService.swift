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
    
    // Configs
    let authTitle = CotterStrings.instance.getText(for: AuthAlertMessagesKey.authTitle)
    let authBody = CotterStrings.instance.getText(for: AuthAlertMessagesKey.authBody)
    let authAction = CotterStrings.instance.getText(for: AuthAlertMessagesKey.authActionButton)
    let authCancel = CotterStrings.instance.getText(for: AuthAlertMessagesKey.authCancelButton)
    
    let successTitle = CotterStrings.instance.getText(for: AuthAlertMessagesKey.successDispatchTitle)
    let successBody = CotterStrings.instance.getText(for: AuthAlertMessagesKey.successDispatchBody)
    let successAction = CotterStrings.instance.getText(for: AuthAlertMessagesKey.successDispatchActionButton)
    let successCancel = CotterStrings.instance.getText(for: AuthAlertMessagesKey.successDispatchCancelButton)
    
    let failureTitle = CotterStrings.instance.getText(for: AuthAlertMessagesKey.failureDispatchTitle)
    let failureBody = CotterStrings.instance.getText(for: AuthAlertMessagesKey.failureDispatchBody)
    let failureAction = CotterStrings.instance.getText(for: AuthAlertMessagesKey.failureDispatchActionButton)
    let failureCancel = CotterStrings.instance.getText(for: AuthAlertMessagesKey.failureDispatchCancelButton)
    
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
        
        let body = try? JSONSerialization.data(withJSONObject: [
            "method": "BIOMETRIC",
            "enrolled": true,
            "code": pubKeyBase64
        ])
        
        // Send the public key to the main server
        CotterAPIService.shared.http(
            method: "PUT",
            path: "/user/"+CotterAPIService.shared.userID!,
            body: body,
            cb: CotterCallback() // TODO: define error handler, don't use default
        )
    }
    
    // pinAuth should authenticate the pin
    public func pinAuth(
        pin: String,
        event: String,
        callback: @escaping ((Bool) -> Void)
    ) throws -> Bool {
        let apiclient = CotterAPIService.shared
        
        // get the external ip address
        var ipAddr = LocalAuthService.ipAddr
        if ipAddr == nil {
            ipAddr = "unknown"
        }
        
        // location is still unknown for 0.0.4
        let location = "unknown"
        
        guard let userID = apiclient.userID else {
            return false
        }
        print("userID: \(userID)")
        
        let data = try? JSONSerialization.data(withJSONObject: [
            "client_user_id": userID,
            "issuer": apiclient.apiKeyID,
            "event": event,
            "ip": ipAddr!, // exclamation mark is fine here because there is a nil check at the top
            "location": location,
            "timestamp": String(format:"%.0f",NSDate().timeIntervalSince1970.rounded()),
            "code": pin,
            "method":"PIN",
            "approved": true
        ])
        
        func successHandler(response:Data?) {
            guard let response = response else {
                print("ERROR: response body is nil")
                return
            }
            let decoder = JSONDecoder()
            do {
                let resp = try decoder.decode(CreateEventResponse.self, from: response)
                callback(resp.approved)
            } catch {
                print(error.localizedDescription)
            }
        }
        
        let h = CotterCallback(
            successfulFunc: successHandler
        )
        
        CotterAPIService.shared.auth(
            body: data,
            cb: h
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
                title: authTitle,
                body: authBody,
                actionButtonTitle: authAction,
                cancelButtonTitle: authCancel
            )
            
            alertDelegate.defActionHandler = {
                aService.hide()
                // this will force biometric scan request
                guard let privateKey = KeyGen.privKey else {
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

                let b64PubKey = CryptoUtil.keyToBase64(pubKey: pubKey)
                
                // TODO: do biometric authentication to the server
                let ipAddr = LocalAuthService.ipAddr ?? "unknown"
                let location = "unknown" // location is unknown as of 0.0.4
                
                let cl = CotterAPIService.shared
                let issuer = cl.apiKeyID
                guard let client_user_id = cl.userID else {
                    print("user id not set")
                    return
                }
                let timestamp = String(format:"%.0f",NSDate().timeIntervalSince1970.rounded())
                let evtMethod = "BIOMETRIC"
                let approved = "true"
                
                let strToBeSigned = client_user_id + issuer + event + timestamp + evtMethod + approved
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

                // create the http request body
                let reqBody = try? JSONSerialization.data(withJSONObject:  [
                    "client_user_id": client_user_id,
                    "issuer": issuer,
                    "event": event,
                    "ip": ipAddr, // exclamation mark is fine here because there is a nil check at the top
                    "location": location,
                    "timestamp": timestamp,
                    "code": strSignature,
                    "method": evtMethod,
                    "public_key": b64PubKey,
                    "approved": true
                ])

                func successHandler(response:Data?) {
                    guard let response = response else {
                        print("ERROR: response body is nil")
                        return
                    }
                    let decoder = JSONDecoder()
                    do {
                        let resp = try decoder.decode(CreateEventResponse.self, from: response)
                        callback(resp.approved)
                    } catch {
                        print(error.localizedDescription)
                    }
                }

                let h = CotterCallback(
                    successfulFunc: successHandler
                )

                // use APIService to send the authentication request
                CotterAPIService.shared.auth(
                    body: reqBody,
                    cb: h
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
                title: authTitle,
                body: authBody,
                actionButtonTitle: authAction,
                cancelButtonTitle: authCancel
            )
            let delegate = LAlertDelegate()
            delegate.defActionHandler = {
                print("got here")
                aService.hide()
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
                cancelButtonTitle: self.successCancel
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
                cancelButtonTitle: self.failureCancel
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
