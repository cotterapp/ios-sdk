//
//  LocalAuthService.swift
//  CotterIOS
//
//  Created by Raymond Andrie on 2/4/20.
//

import Foundation
import LocalAuthentication

class LocalAuthService {
    
    // Configs
    let failAuthTitle = "Authentication Failed"
    let failAuthMsg = "You could not be verified; please try again."
    let noAuthTitle = "Biometrics unavailable"
    let noAuthMsg = "Your device is not configured for biometric authentication"
    
    
    // Configure Local Authentication
    public func authenticate(view: UIViewController, reason: String, callback: ((String) -> Void)?) {
        let context = LAContext()
        var error: NSError?
        
        // Check if we can use biometrics
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { [weak self, weak view] success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        print("Successfully authenticated!")
                        // Run callback
                        callback?("This is token!")
                    } else {
                        // Failed authentication
                        let ac = UIAlertController(title: self?.failAuthTitle, message: self?.failAuthMsg, preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "Ok", style: .default))
                        view?.present(ac, animated: true)
                    }
                }
        }
        } else {
            // No biometrics for device
            let ac = UIAlertController(title: noAuthTitle, message: noAuthMsg, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Ok", style: .default))
            view.present(ac, animated: true)
            // TODO: Input PIN again?
            // Temporary: Run callback
            callback?("This is token!")
        }
    }
}
