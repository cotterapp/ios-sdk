//
//  BiometricRegistrationFailPopup.swift
//  Cotter
//
//  Created by Albert Purnama on 11/2/20.
//

import Foundation

class BiometricRegistrationFailPopup: BottomPopupModalDelegate {
    static let failureTitle = CotterStrings.instance.getText(for: AuthAlertMessagesKey.failureDispatchTitle)
    static let failureBody = CotterStrings.instance.getText(for: AuthAlertMessagesKey.failureDispatchBody)
    static let failureAction = CotterStrings.instance.getText(for: AuthAlertMessagesKey.failureDispatchActionButton)
    static let failureCancel = CotterStrings.instance.getText(for: AuthAlertMessagesKey.verifyAuthCancelButton)
    
    // MARK: - Image Path Definitions
    static let bioFailImg = CotterImages.instance.getImage(for: AlertImageKey.failureBiometricImg)
    
    let popup = BottomPopupModal(
        img: getUIImage(imagePath: bioFailImg),
        title: failureTitle,
        body: failureBody,
        actionText: failureAction,
        cancelText: failureCancel
    )
    
    var bioService: BiometricServiceDelegate
    
    public init (bioService: BiometricServiceDelegate) {
        self.bioService = bioService
        popup.delegate = self
    }
    
    public func show() {
        LoadingScreen.shared.stop()
        popup.show()
    }
    
    func dismissCompletion() {
        // noops
    }
    
    func actionHandler() {
        popup.dismiss(animated: false)
        bioService.start()
    }
    
    func cancelHandler() {
        popup.dismiss(animated: false)
        bioService.authCallback("cancelled", CotterError.verificationCancelled)
    }
}

