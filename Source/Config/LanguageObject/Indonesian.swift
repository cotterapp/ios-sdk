//
//  Indonesian.swift
//  CotterIOS
//
//  Created by Calvin Tjoeng on 2/7/20.
//

import Foundation

class Indonesian: LanguageObject {
    init() {
        super.init(text: [
            // MARK: - PINViewController
            PINViewControllerKey.showPin: "Lihat PIN",
            PINViewControllerKey.hidePin: "Sembunyikan",
            PINViewControllerKey.closeTitle: "Yakin tidak Mau Buat PIN Sekarang?",
            PINViewControllerKey.closeMessage: "PIN Ini diperlukan untuk keamanan akunmu, lho.",
            PINViewControllerKey.stayOnView: "Input PIN",
            PINViewControllerKey.leaveView: "Lain Kali",
            PINViewControllerKey.title: "Buat PIN untuk keamanan akunmu",
            
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
            PINFinalViewController.title: "PIN Sukses Didaftarkan!",
            PINFinalViewController.subtitle: "Mulai sekarang kamu bisa login dan konfirmasi transaksi menggunakan PIN",
            PINFinalViewController.buttonText: "Selesai",
            
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
