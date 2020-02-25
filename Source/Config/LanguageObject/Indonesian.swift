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
            PINViewControllerKey.navTitle: "Aktivasi PIN",
            PINViewControllerKey.showPin: "Lihat PIN",
            PINViewControllerKey.hidePin: "Sembunyikan",
            PINViewControllerKey.title: "Buat PIN untuk keamanan akunmu",
            PINViewControllerKey.closeTitle: "Yakin tidak Mau Buat PIN Sekarang?",
            PINViewControllerKey.closeMessage: "PIN Ini diperlukan untuk keamanan akunmu, lho.",
            PINViewControllerKey.stayOnView: "Input PIN",
            PINViewControllerKey.leaveView: "Lain Kali",
            
            // MARK: - PINConfirmViewController
            PINConfirmViewControllerKey.navTitle: "Konfirmasi PIN",
            PINConfirmViewControllerKey.showPin: "Lihat PIN",
            PINConfirmViewControllerKey.hidePin: "Sembunyikan",
            PINConfirmViewControllerKey.title: "Masukkan PIN sekali lagi untuk konfirmasi",
            PINConfirmViewControllerKey.closeTitle: "Yakin tidak Mau Buat PIN Sekarang?",
            PINConfirmViewControllerKey.closeMessage: "PIN Ini diperlukan untuk keamanan akunmu, lho.",
            PINConfirmViewControllerKey.stayOnView: "Input PIN",
            PINConfirmViewControllerKey.leaveView: "Lain Kali",
            
            // MARK: - PINFinalViewController
            PINFinalViewControllerKey.closeTitle: "Verifikasi",
            PINFinalViewControllerKey.closeMessage: "Sentuh sensor sidik jari untuk melanjutkan",
            PINFinalViewControllerKey.stayOnView: "Input PIN",
            PINFinalViewControllerKey.leaveView: "Batalkan",
            PINFinalViewControllerKey.successImage: "default-cotter-img",
            PINFinalViewControllerKey.title: "PIN Sukses Didaftarkan!",
            PINFinalViewControllerKey.subtitle: "Mulai sekarang kamu bisa login dan konfirmasi transaksi menggunakan PIN",
            PINFinalViewControllerKey.buttonText: "Selesai",
            
            // MARK: - TransactionPINViewController
            TransactionPINViewControllerKey.navTitle: "Verifikasi",
            TransactionPINViewControllerKey.showPin: "Lihat PIN",
            TransactionPINViewControllerKey.hidePin: "Sembunyikan",
            TransactionPINViewControllerKey.title: "Masukkan PIN",
            TransactionPINViewControllerKey.closeTitle: "Yakin tidak Mau Buat PIN Sekarang?",
            TransactionPINViewControllerKey.closeMessage: "PIN Ini diperlukan untuk keamanan akunmu, lho.",
            TransactionPINViewControllerKey.stayOnView: "Input PIN",
            TransactionPINViewControllerKey.leaveView: "Lain Kali",
            
            // MARK: - UpdatePINViewController
            UpdatePINViewControllerKey.navTitle: "Ubah PIN",
            UpdatePINViewControllerKey.showPin: "Lihat PIN",
            UpdatePINViewControllerKey.hidePin: "Sembunyikan",
            UpdatePINViewControllerKey.title: "Masukkan PIN saat ini",
            
            // MARK: - UpdateCreateNewPINViewController
            UpdateCreateNewPINViewControllerKey.navTitle: "PIN Baru",
            UpdateCreateNewPINViewControllerKey.showPin: "Lihat PIN",
            UpdateCreateNewPINViewControllerKey.hidePin: "Sembunyikan",
            UpdateCreateNewPINViewControllerKey.title: "Masukkan PIN baru",
            
            // MARK: - UpdateConfirmNewPINViewController
            UpdateConfirmNewPINViewControllerKey.navTitle: "Konfirmasi PIN",
            UpdateConfirmNewPINViewControllerKey.showPin: "Lihat PIN",
            UpdateConfirmNewPINViewControllerKey.hidePin: "Sembunyikan",
            UpdateConfirmNewPINViewControllerKey.title: "Masukin PIN baru sekali lagi untuk konfirmasi",
        ])
    }
}
