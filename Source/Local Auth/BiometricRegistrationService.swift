//
//  BiometricRegistrationService.swift
//  Cotter
//
//  Created by Albert Purnama on 9/17/20.
//

import Foundation
import UIKit
import os.log
import LocalAuthentication

class BiometricRegistrationService {
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
    
    private func biometricPubKeyRegistration(pubKey: SecKey) {
        let pubKeyBase64 = CryptoUtil.keyToBase64(pubKey: pubKey)
        
        let userID = CotterAPIService.shared.cotterUserID
        
        // Send the public key to the main server
        CotterAPIService.shared.registerBiometric(userID:userID, pubKey:pubKeyBase64, cb:DefaultResultCallback)
    }
}

extension BiometricRegistrationService: BiometricServiceDelegate {
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
            self.authCallback("token", nil)
        }
    }
}

extension BiometricRegistrationService: BottomPopupModalDelegate {
    @objc func actionHandler() {
        bottomPopupScanPrompt.dismiss(animated: false)
    
        // this will force biometric scan request
        guard KeyStore.biometric.privKey != nil else {
            BiometricFailPopup(bioService: self).show()
            return
        }

        // get the public key, this will trigger the faceID
        guard let pubKey = KeyStore.biometric.pubKey else {
            BiometricFailPopup(bioService: self).show()
            return
        }

        self.biometricPubKeyRegistration(pubKey: pubKey)
        BiometricSuccessPopup(bioService: self).show()
    }
    
    @objc func cancelHandler() {
        self.authCallback("token", nil)
    }
    
    func dismissCompletion() {
        // noop
    }
}
