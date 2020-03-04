//
//  English.swift
//  CotterIOS
//
//  Created by Calvin Tjoeng on 2/7/20.
//

import Foundation

public class English: LanguageObject {
    public init() {
        super.init(text: [
            // MARK: - PINViewController
            PINViewControllerKey.navTitle: "Activate PIN",
            PINViewControllerKey.showPin: "Show PIN",
            PINViewControllerKey.hidePin: "Hide PIN",
            PINViewControllerKey.title: "Create a PIN to secure your account",
            
            // MARK: - PINConfirmViewController
            PINConfirmViewControllerKey.navTitle: "Activate PIN",
            PINConfirmViewControllerKey.showPin: "Show PIN",
            PINConfirmViewControllerKey.hidePin: "Hide PIN",
            PINConfirmViewControllerKey.title: "Confirm your PIN combination",
            
            // MARK: - PINFinalViewController
            PINFinalViewControllerKey.title: "Successfully Activated PIN!",
            PINFinalViewControllerKey.subtitle: "You can now use your PIN to unlock your account and make transactions",
            PINFinalViewControllerKey.buttonText: "Done",
            
            // MARK: - TransactionPINViewController
            TransactionPINViewControllerKey.navTitle: "Verification",
            TransactionPINViewControllerKey.showPin: "Show PIN",
            TransactionPINViewControllerKey.hidePin: "Hide PIN",
            TransactionPINViewControllerKey.title: "Enter your PIN",
            
            // MARK: - UpdatePINViewController
            UpdatePINViewControllerKey.navTitle: "Change PIN",
            UpdatePINViewControllerKey.showPin: "Show PIN",
            UpdatePINViewControllerKey.hidePin: "Hide PIN",
            UpdatePINViewControllerKey.title: "Enter your Current PIN",
            
            // MARK: - UpdateCreateNewPINViewController
            UpdateCreateNewPINViewControllerKey.navTitle: "Update PIN",
            UpdateCreateNewPINViewControllerKey.showPin: "Show PIN",
            UpdateCreateNewPINViewControllerKey.hidePin: "Hide PIN",
            UpdateCreateNewPINViewControllerKey.title: "Enter your New PIN",
            
            // MARK: - UpdateConfirmNewPINViewController
            UpdateConfirmNewPINViewControllerKey.navTitle: "Confirm PIN",
            UpdateConfirmNewPINViewControllerKey.showPin: "Show PIN",
            UpdateConfirmNewPINViewControllerKey.hidePin: "Hide PIN",
            UpdateConfirmNewPINViewControllerKey.title: "Confirm your new PIN",
            
            // MARK: - Error Messages
            PinErrorMessagesKey.incorrectPinConfirmation: "Incorrect PIN Confirmation. Please enter the correct PIN and try again.",
            PinErrorMessagesKey.badPin: "The PIN combination you have entered is insecure. Please enter a stronger PIN.",
            PinErrorMessagesKey.incorrectPinVerification: "PIN Verification failed. Please try again.",
            PinErrorMessagesKey.similarPinAsBefore: "Unable to use the same PIN as before. Please try again.",
            PinErrorMessagesKey.enrollPinFailed: "PIN Enrollment failed. Please try again.",
            PinErrorMessagesKey.updatePinFailed: "Update PIN failed. Please try again.",
            PinErrorMessagesKey.networkError: "Please check your internet connection, then try again.",
            PinErrorMessagesKey.apiError: "Internal Server Error. Please contact Customer Support.",
            
            // MARK: - Navigate Back Alert
            AuthAlertMessagesKey.navBackTitle: "Are you sure you want to cancel?",
            AuthAlertMessagesKey.navBackBody: "Do you know that PIN creates additional security layer for your account?",
            AuthAlertMessagesKey.navBackActionButton: "Yes",
            AuthAlertMessagesKey.navBackCancelButton: "Input PIN",
            
            // MARK: - Biometric Enrollment Authentication Alert
            AuthAlertMessagesKey.enrollAuthTitle: "Biometric Verification",
            AuthAlertMessagesKey.enrollAuthBody: "Protect your account using Biometrics",
            AuthAlertMessagesKey.enrollAuthActionButton: "Continue",
            AuthAlertMessagesKey.enrollAuthCancelButton: "Use PIN",
            
            // MARK: - Biometric Verification Authentication Alert
            AuthAlertMessagesKey.verifyAuthTitle: "Verify Biometrics",
            AuthAlertMessagesKey.verifyAuthBody: "Verify your biometrics to continue",
            AuthAlertMessagesKey.verifyAuthActionButton: "Continue",
            AuthAlertMessagesKey.verifyAuthCancelButton: "Use PIN",
            
            // MARK: - Dispatch Result Alert (Success)
            AuthAlertMessagesKey.successDispatchTitle: "Verification",
            AuthAlertMessagesKey.successDispatchBody: "Biometrics Successful.",
            AuthAlertMessagesKey.successDispatchActionButton: "Continue",
            AuthAlertMessagesKey.successDispatchCancelButton: "Cancel",
            
            // MARK: - Dispatch Result Alert (Failure)
            AuthAlertMessagesKey.failureDispatchTitle: "Verification",
            AuthAlertMessagesKey.failureDispatchBody: "Biometrics Failed.",
            AuthAlertMessagesKey.failureDispatchActionButton: "Try Again",
            AuthAlertMessagesKey.failureDispatchCancelButton: "Cancel",
            
        ])
    }
}
