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
            PINViewControllerKey.showPin: "Show",
            PINViewControllerKey.hidePin: "Hide",
            PINViewControllerKey.closeTitle: "Are you sure you want to cancel?",
            PINViewControllerKey.closeMessage: "Do you know that PIN creates additional security layer for your account?",
            PINViewControllerKey.stayOnView: "Input PIN",
            PINViewControllerKey.leaveView: "Yes",
            PINViewControllerKey.title: "Create PIN to secure your account",
            
            // MARK: - PINConfirmViewController
            PINConfirmViewControllerKey.showPin: "Show",
            PINConfirmViewControllerKey.hidePin: "Hide",
            PINConfirmViewControllerKey.closeTitle: "Yakin tidak Mau Buat PIN Sekarang?",
            PINConfirmViewControllerKey.closeMessage: "PIN Ini diperlukan untuk keamanan akunmu, lho.",
            PINConfirmViewControllerKey.stayOnView: "Input PIN",
            PINConfirmViewControllerKey.leaveView: "Lain Kali",
            PINConfirmViewControllerKey.title: "Confirm your PIN combination",
            
            // MARK: - PINFinalViewController
            PINFinalViewControllerKey.closeTitle: "Verifikasi",
            PINFinalViewControllerKey.closeMessage: "Sentuh sensor sidik jari untuk melanjutkan",
            PINFinalViewControllerKey.stayOnView: "Input PIN",
            PINFinalViewControllerKey.leaveView: "Batalkan",
            PINFinalViewControllerKey.title: "Successfully Activated PIN!",
            PINFinalViewControllerKey.subtitle: "You can now use your PIN to unlock your account and make transactions",
            PINFinalViewControllerKey.buttonText: "Done",
            
            // MARK: - TransactionPINViewController
            TransactionPINViewControllerKey.showPin: "Lihat PIN",
            TransactionPINViewControllerKey.hidePin: "Sembunyikan",
            TransactionPINViewControllerKey.closeTitle: "Yakin tidak Mau Buat PIN Sekarang?",
            TransactionPINViewControllerKey.closeMessage: "PIN Ini diperlukan untuk keamanan akunmu, lho.",
            TransactionPINViewControllerKey.stayOnView: "Input PIN",
            TransactionPINViewControllerKey.leaveView: "Lain Kali",
            
            // MARK: - UpdatePINViewController
            UpdatePINViewControllerKey.showPin: "Lihat PIN",
            UpdatePINViewControllerKey.hidePin: "Sembunyikan",
            
            // MARK: - UpdateCreateNewPINViewController
            UpdateCreateNewPINViewControllerKey.showPin: "Lihat PIN",
            UpdateCreateNewPINViewControllerKey.hidePin: "Sembunyikan",
            
            // MARK: - UpdateConfirmNewPINViewController
            UpdateConfirmNewPINViewControllerKey.showPin: "Lihat PIN",
            UpdateConfirmNewPINViewControllerKey.hidePin: "Sembunyikan",
        ])
    }
}
