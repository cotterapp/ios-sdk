//
//  BiometricService.swift
//  Cotter
//
//  Created by Albert Purnama on 9/17/20.
//

import Foundation
import UIKit
import os.log
import LocalAuthentication

protocol BiometricServiceDelegate {
    var authCallback: FinalAuthCallback { get }
    
    func start()
}

class BiometricAuthenticationService {
    static let verifyAuthTitle = CotterStrings.instance.getText(for: AuthAlertMessagesKey.verifyAuthTitle)
    static let verifyAuthBody = CotterStrings.instance.getText(for: AuthAlertMessagesKey.verifyAuthBody)
    static let verifyAuthAction = CotterStrings.instance.getText(for: AuthAlertMessagesKey.verifyAuthActionButton)
    static let verifyAuthCancel = CotterStrings.instance.getText(for: AuthAlertMessagesKey.verifyAuthCancelButton)
    
    // MARK: - Image Path Definitions
    static let fingerprintImg = CotterImages.instance.getImage(for: AlertImageKey.promptVerificationImg)
    
    var event: String
    var authCallback: FinalAuthCallback
    
    public init(event: String, callback: @escaping FinalAuthCallback) {
        self.event = event
        self.authCallback = callback
    }
    
    let bottomPopupScanPrompt = BottomPopupModal(
        img: getUIImage(imagePath: fingerprintImg),
        title: verifyAuthTitle,
        body: verifyAuthBody,
        actionText: verifyAuthAction,
        cancelText: verifyAuthCancel
    )
}

extension BiometricAuthenticationService: BiometricServiceDelegate {
    func start() {
        let context = LAContext()
        var error: NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            bottomPopupScanPrompt.delegate = self
            bottomPopupScanPrompt.show()
            let seconds = 0.1
            DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                // Put your code which should be executed with a delay here
                self.actionHandler()
            }
        } else {
            // no biometric then do nothing
            os_log("%{public}@ biometric not available",
                   log: Config.instance.log, type: .debug,
                   #function)
        }
    }
}

extension BiometricAuthenticationService: BottomPopupModalDelegate {
    @objc func actionHandler() {
        guard let privateKey = KeyStore.biometric.privKey else {
            bottomPopupScanPrompt.dismiss(animated: false)
            BiometricFailPopup(bioService: self).show()
            return
        }
        
        // TODO: should derive pubKey from privateKey
        guard let pubKey = KeyStore.biometric.pubKey else {
            bottomPopupScanPrompt.dismiss(animated: false)
            BiometricFailPopup(bioService: self).show()
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
                authCallback(resp.approved ? "true": "false", nil)
            case .failure(let err):
                LoadingScreen.shared.stop()
                authCallback("", err)
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
        bottomPopupScanPrompt.dismiss(animated: false)
    }
    
    @objc func cancelHandler() {
        bottomPopupScanPrompt.dismiss(animated: false)
    }
    
    func dismissCompletion() {
        // noop
    }
}
