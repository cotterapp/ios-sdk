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
            PINConfirmViewControllerKey.title: "Confirm your PIN Combination",
            
            // MARK: - PINFinalViewController
            PINFinalViewControllerKey.title: "Successfully Activated PIN!",
            PINFinalViewControllerKey.subtitle: "You can now use your PIN to unlock your account and make transactions",
            PINFinalViewControllerKey.buttonText: "Done",
            
            // MARK: - TransactionPINViewController
            TransactionPINViewControllerKey.navTitle: "Verification",
            TransactionPINViewControllerKey.showPin: "Show PIN",
            TransactionPINViewControllerKey.hidePin: "Hide PIN",
            TransactionPINViewControllerKey.forgetPin: "Forgot your PIN?",
            TransactionPINViewControllerKey.title: "Enter your PIN",
            
            // MARK: - ResetPINViewController
            ResetPINViewControllerKey.navTitle: "Forgot PIN",
            ResetPINViewControllerKey.title: "Verification Code",
            ResetPINViewControllerKey.subtitle: "We have sent the code to",
            ResetPINViewControllerKey.resetFailSub: "Please contact customer service to reset your PIN.",
            ResetPINViewControllerKey.resendEmail: "Resend Email",
            
            // MARK: - ResetNewPINViewController
            ResetNewPINViewControllerKey.navTitle: "Activate new PIN",
            ResetNewPINViewControllerKey.showPin: "Show PIN",
            ResetNewPINViewControllerKey.hidePin: "Hide PIN",
            ResetNewPINViewControllerKey.title: "Enter your new PIN",
            
            // MARK: - ResetConfirmPINController
            ResetConfirmPINViewControllerKey.navTitle: "Confirm new PIN",
            ResetConfirmPINViewControllerKey.showPin: "Show PIN",
            ResetConfirmPINViewControllerKey.hidePin: "Hide PIN",
            ResetConfirmPINViewControllerKey.title: "Confirm your new PIN",
            
            // MARK: - ResetPINFinalViewController
            ResetPINFinalViewControllerKey.title: "New PIN successfully created!",
            
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
            
            // MARK: - PIN Error Messages
            PinErrorMessagesKey.incorrectPinConfirmation: "Your PIN doesn't match your previous PIN.",
            PinErrorMessagesKey.badPin: "Your PIN is weak. Please enter a stronger PIN.",
            PinErrorMessagesKey.incorrectPinVerification: "Your PIN is invalid.",
            PinErrorMessagesKey.similarPinAsBefore: "Unable to use the same PIN as before. Please try again.",
            PinErrorMessagesKey.incorrectEmailCode: "Email verification code incorrect.",
            PinErrorMessagesKey.enrollPinFailed: "PIN Enrollment failed. Please try again.",
            PinErrorMessagesKey.updatePinFailed: "Update PIN failed. Please try again.",
            PinErrorMessagesKey.resetPinFailed: "Reset PIN failed. Please try again.",
            PinErrorMessagesKey.unableToResetPin: "Unable to continue with Reset PIN Process.",
            PinErrorMessagesKey.networkError: "Please check your internet connection, then try again.",
            PinErrorMessagesKey.apiError: "Internal Server Error. Please contact Customer Support.",
            
            // MARK: - Navigate Back Alert
            AuthAlertMessagesKey.navBackTitle: "Are you sure you don't want to setup PIN?",
            AuthAlertMessagesKey.navBackBody: "Setting up your PIN is important to secure your account.",
            AuthAlertMessagesKey.navBackActionButton: "Next Time",
            AuthAlertMessagesKey.navBackCancelButton: "Setup PIN",
            
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
            AuthAlertMessagesKey.failureDispatchTitle: "Unable to verify biometric",
            AuthAlertMessagesKey.failureDispatchBody: "Do you want to try again or enter pin instead?",
            AuthAlertMessagesKey.failureDispatchActionButton: "Try Again",
            AuthAlertMessagesKey.failureDispatchCancelButton: "Cancel",
            
        ])
    }
}
