//
//  BiometricSuccessPopup.swift
//  Cotter
//
//  Created by Albert Purnama on 9/17/20.
//

import Foundation

class BiometricSuccessPopup: BottomPopupModalDelegate {
    static let title = CotterStrings.instance.getText(for: AuthAlertMessagesKey.successDispatchTitle)
    static let body = CotterStrings.instance.getText(for: AuthAlertMessagesKey.successDispatchBody)
    static let actionText = CotterStrings.instance.getText(for: AuthAlertMessagesKey.successDispatchActionButton)
    static let cancelText = CotterStrings.instance.getText(for: AuthAlertMessagesKey.successDispatchCancelButton)
    
    // MARK: - Image Path Definitions
    static let img = CotterImages.instance.getImage(for: AlertImageKey.successVerificationImg)

    let popup = BottomPopupModal(
        img: getUIImage(imagePath: img),
        title: title,
        body: body,
        actionText: actionText,
        cancelText: cancelText
    )
    
    let bioService: BiometricServiceDelegate
    
    public init (bioService: BiometricServiceDelegate) {
        self.bioService = bioService
        popup.delegate = self
    }
    
    public func show() {
        LoadingScreen.shared.stop()
        
        popup.show()
        
        // Dismiss Alert after 3 seconds, then run callback
        let timer = DispatchTime.now() + 2
        DispatchQueue.main.asyncAfter(deadline: timer) {
            self.popup.dismiss(animated: false)
        }
    }
    
    func dismissCompletion() {
        self.bioService.authCallback("success", nil)
    }
    
    func actionHandler() {
        // noop
    }
    
    func cancelHandler() {
        // noop
    }
}
