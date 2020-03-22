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
            
            // MARK: - PINConfirmViewController
            PINConfirmViewControllerKey.navTitle: "Konfirmasi PIN",
            PINConfirmViewControllerKey.showPin: "Lihat PIN",
            PINConfirmViewControllerKey.hidePin: "Sembunyikan",
            PINConfirmViewControllerKey.title: "Masukkan PIN sekali lagi untuk konfirmasi",
            
            // MARK: - PINFinalViewController
            PINFinalViewControllerKey.title: "PIN Sukses Didaftarkan!",
            PINFinalViewControllerKey.subtitle: "Mulai sekarang kamu bisa login dan konfirmasi transaksi menggunakan PIN",
            PINFinalViewControllerKey.buttonText: "Selesai",
            
            // MARK: - TransactionPINViewController
            TransactionPINViewControllerKey.navTitle: "Verifikasi",
            TransactionPINViewControllerKey.showPin: "Lihat PIN",
            TransactionPINViewControllerKey.hidePin: "Sembunyikan",
            TransactionPINViewControllerKey.forgetPin: "Lupa PIN",
            TransactionPINViewControllerKey.title: "Masukkan PIN",
            
            // MARK: - ResetPINViewController
            ResetPINViewControllerKey.navTitle: "Lupa PIN",
            ResetPINViewControllerKey.title: "Kode Keamanan",
            ResetPINViewControllerKey.subtitle: "Kami telah mengirimkan kode ke ",
            ResetPINViewControllerKey.resendEmail: "Kirim ulang email",
            
            // MARK: - ResetNewPINViewController
            ResetNewPINViewControllerKey.navTitle: "Aktivasi PIN Baru",
            ResetNewPINViewControllerKey.showPin: "Lihat PIN",
            ResetNewPINViewControllerKey.hidePin: "Sembunyikan",
            ResetNewPINViewControllerKey.title: "Buat PIN untuk keamanan akunmu",
            
            // MARK: - ResetConfirmPINController
            ResetConfirmPINViewControllerKey.navTitle: "Konfirmasi PIN Baru",
            ResetConfirmPINViewControllerKey.showPin: "Lihat PIN",
            ResetConfirmPINViewControllerKey.hidePin: "Sembunyikan",
            ResetConfirmPINViewControllerKey.title: "Masukkan PIN sekali lagi untuk konfirmasi",
            
            // MARK: - ResetPINFinalViewController
            ResetPINFinalViewControllerKey.title: "PIN baru berhasil dibuat!",
            
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
            
            // MARK: - Pin Error Messages
            PinErrorMessagesKey.incorrectPinConfirmation: "Kamu perlu memasukkan PIN yang sama seperti sebelumnya.",
            PinErrorMessagesKey.badPin: "PIN terlalu mudah. Yuk buat PIN baru dengan kombinasi lebih sulit.",
            PinErrorMessagesKey.incorrectPinVerification: "PIN buat verifikasi salah. Coba lagi.",
            PinErrorMessagesKey.similarPinAsBefore: "PIN sama ama dulu punya. Coba ganti PIN baru.",
            PinErrorMessagesKey.incorrectEmailCode: "Kode yang kamu masukkan salah",
            PinErrorMessagesKey.enrollPinFailed: "PIN Registrasi gagal. Silahkan coba lagi.",
            PinErrorMessagesKey.updatePinFailed: "Membarui PIN gagal. Silahkan coba lagi.",
            PinErrorMessagesKey.resetPinFailed: "Atur ulang PIN gagal. Silahkan coba lagi.",
            PinErrorMessagesKey.networkError: "Coba periksa koneksi internet, terus coba lagi.",
            PinErrorMessagesKey.apiError: "Kesalahan dalam server. Silahkan hubungi layanan pelanggan.",
            
            // MARK: - Navigate Back Alert
            AuthAlertMessagesKey.navBackTitle: "Yakin tidak Mau Buat PIN Sekarang?",
            AuthAlertMessagesKey.navBackBody: "PIN Ini diperlukan untuk keamanan akunmu, lho.",
            AuthAlertMessagesKey.navBackActionButton: "Lain Kali",
            AuthAlertMessagesKey.navBackCancelButton: "Input PIN",
            
            // MARK: - Biometric Enrollment Authentication Alert
            AuthAlertMessagesKey.enrollAuthTitle: "Verifikasi",
            AuthAlertMessagesKey.enrollAuthBody: "Lanjutkan untuk menggunakan verifikasi TouchID atau FaceID",
            AuthAlertMessagesKey.enrollAuthActionButton: "Lanjutkan",
            AuthAlertMessagesKey.enrollAuthCancelButton: "Gunakan PIN",
            
            // MARK: - Biometric Verification Authentication Alert
            AuthAlertMessagesKey.verifyAuthTitle: "Verifikasi",
            AuthAlertMessagesKey.verifyAuthBody: "Verifikasi biometrik Anda untuk melanjutkan",
            AuthAlertMessagesKey.verifyAuthActionButton: "Lanjutkan",
            AuthAlertMessagesKey.verifyAuthCancelButton: "Gunaken PIN",
            
            // MARK: - Dispatch Result Alert (Success)
            AuthAlertMessagesKey.successDispatchTitle: "Verifikasi",
            AuthAlertMessagesKey.successDispatchBody: "Sidik biometrik sesuai.",
            AuthAlertMessagesKey.successDispatchActionButton: "Input PIN",
            AuthAlertMessagesKey.successDispatchCancelButton: "Batalkan",
            
            // MARK: - Dispatch Result Alert (Failure)
            AuthAlertMessagesKey.failureDispatchTitle: "Verifikasi",
            AuthAlertMessagesKey.failureDispatchBody: "Biometrik gagal.",
            AuthAlertMessagesKey.failureDispatchActionButton: "Coba Lagi",
            AuthAlertMessagesKey.failureDispatchCancelButton: "Input PIN",
            
        ])
    }
}
