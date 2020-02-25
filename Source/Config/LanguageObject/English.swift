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
            PINViewControllerKey.showPin: "Show",
            PINViewControllerKey.hidePin: "Hide",
            PINViewControllerKey.closeTitle: "Are you sure you want to cancel?",
            PINViewControllerKey.closeMessage: "Do you know that PIN creates additional security layer for your account?",
            PINViewControllerKey.stayOnView: "Input PIN",
            PINViewControllerKey.leaveView: "Yes",
            PINViewControllerKey.title: "Create a PIN to secure your account",
            
            // MARK: - PINConfirmViewController
            PINConfirmViewControllerKey.navTitle: "Activate PIN",
            PINConfirmViewControllerKey.showPin: "Show",
            PINConfirmViewControllerKey.hidePin: "Hide",
            PINConfirmViewControllerKey.closeTitle: "Are you sure you want to cancel?",
            PINConfirmViewControllerKey.closeMessage: "Do you know that PIN creates additional security layer for your account?",
            PINConfirmViewControllerKey.stayOnView: "Input PIN",
            PINConfirmViewControllerKey.leaveView: "Yes",
            PINConfirmViewControllerKey.title: "Confirm your PIN combination",
            
            // MARK: - PINFinalViewController
            PINFinalViewControllerKey.closeTitle: "Verification",
            PINFinalViewControllerKey.closeMessage: "Please provide biometric authentication to continue",
            PINFinalViewControllerKey.stayOnView: "Input PIN",
            PINFinalViewControllerKey.leaveView: "Exit",
            PINFinalViewControllerKey.successImage: "default-cotter-img",
            PINFinalViewControllerKey.title: "Successfully Activated PIN!",
            PINFinalViewControllerKey.subtitle: "You can now use your PIN to unlock your account and make transactions",
            PINFinalViewControllerKey.buttonText: "Done",
            
            // MARK: - TransactionPINViewController
            TransactionPINViewControllerKey.navTitle: "Verification",
            TransactionPINViewControllerKey.showPin: "Show PIN",
            TransactionPINViewControllerKey.hidePin: "Hide PIN",
            TransactionPINViewControllerKey.title: "Enter your PIN",
            TransactionPINViewControllerKey.closeTitle: "Are you sure you want to cancel?",
            TransactionPINViewControllerKey.closeMessage: "Do you know that PIN creates additional security layer for your account?",
            TransactionPINViewControllerKey.stayOnView: "Input PIN",
            TransactionPINViewControllerKey.leaveView: "Yes",
            
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
        ])
    }
}
