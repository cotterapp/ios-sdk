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
            PINViewController.showPin: "Lihat PIN",
            PINViewController.hidePin: "Sembunyikan",
            PINViewController.closeTitle: "Yakin tidak Mau Buat PIN Sekarang?",
            PINViewController.closeMessage: "PIN Ini diperlukan untuk keamanan akunmu, lho.",
            PINViewController.stayOnView: "Input PIN",
            PINViewController.leaveView: "Lain Kali",
            
            // MARK: - PINConfirmViewController
            PINConfirmViewController.showPin: "Lihat PIN",
            PINConfirmViewController.hidePin: "Sembunyikan",
            PINConfirmViewController.closeTitle: "Yakin tidak Mau Buat PIN Sekarang?",
            PINConfirmViewController.closeMessage: "PIN Ini diperlukan untuk keamanan akunmu, lho.",
            PINConfirmViewController.stayOnView: "Input PIN",
            PINConfirmViewController.leaveView: "Lain Kali",
            
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
