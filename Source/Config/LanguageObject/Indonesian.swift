//
//  Indonesian.swift
//  CotterIOS
//
//  Created by Calvin Tjoeng on 2/7/20.
//

import Foundation

public class Indonesian: LanguageObject {
    public init() {
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
            PINConfirmViewControllerKey.title: "Masukkan PIN sekali lagi untuk konfirmasi",
            
            // MARK: - PINFinalViewController
            PINFinalViewControllerKey.closeTitle: "Verifikasi",
            PINFinalViewControllerKey.closeMessage: "Sentuh sensor sidik jari untuk melanjutkan",
            PINFinalViewControllerKey.stayOnView: "Input PIN",
            PINFinalViewControllerKey.leaveView: "Batalkan",
            PINFinalViewControllerKey.title: "PIN Sukses Didaftarkan!",
            PINFinalViewControllerKey.subtitle: "Mulai sekarang kamu bisa login dan konfirmasi transaksi menggunakan PIN",
            PINFinalViewControllerKey.buttonText: "Selesai",
            
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
