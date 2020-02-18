//
//  English.swift
//  CotterIOS
//
//  Created by Calvin Tjoeng on 2/7/20.
//

import Foundation

class English: LanguageObject {
    init() {
        super.init(text: [
            // MARK: - PINViewController
            PINViewControllerKey.showPin: "Show",
            PINViewControllerKey.hidePin: "Hide",
            PINViewControllerKey.closeTitle: "Are you sure you want to cancel?",
            PINViewControllerKey.closeMessage: "Do you know that PIN creates additional security layer for your account?",
            PINViewControllerKey.stayOnView: "Input PIN",
            PINViewControllerKey.leaveView: "Yes",
            PINViewControllerKey.title: "Create PIN to secure your account",
            
            // MARK: - PINConfirmViewController
            PINConfirmViewControllerKey.showPin: "Lihat PIN",
            PINConfirmViewControllerKey.hidePin: "Sembunyikan",
            PINConfirmViewControllerKey.closeTitle: "Yakin tidak Mau Buat PIN Sekarang?",
            PINConfirmViewControllerKey.closeMessage: "PIN Ini diperlukan untuk keamanan akunmu, lho.",
            PINConfirmViewControllerKey.stayOnView: "Input PIN",
            PINConfirmViewControllerKey.leaveView: "Lain Kali",
            
            // MARK: - PINFinalViewController
            PINFinalViewController.closeTitle: "Verifikasi",
            PINFinalViewController.closeMessage: "Sentuh sensor sidik jari untuk melanjutkan",
            PINFinalViewController.stayOnView: "Input PIN",
            PINFinalViewController.leaveView: "Batalkan",
            PINFinalViewController.title: "Successfully Activated PIN!",
            PINFinalViewController.subtitle: "You can now use your PIN to unlock your account and make transactions",
            PINFinalViewController.buttonText: "Done",
            
            // MARK: - TransactionPINViewController
            TransactionPINViewController.showPin: "Lihat PIN",
            TransactionPINViewController.hidePin: "Sembunyikan",
            TransactionPINViewController.closeTitle: "Yakin tidak Mau Buat PIN Sekarang?",
            TransactionPINViewController.closeMessage: "PIN Ini diperlukan untuk keamanan akunmu, lho.",
            TransactionPINViewController.stayOnView: "Input PIN",
            TransactionPINViewController.leaveView: "Lain Kali",
        ])
    }
}
