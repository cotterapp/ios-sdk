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
            ResetPINViewControllerKey.subtitle: "Kami telah mengirimkan kode ke",
            ResetPINViewControllerKey.resetFailSub: "Silakan hubungi layanan pelanggan untuk mengatur ulang pin Anda",
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
            
            // MARK: - TrustedViewController
            TrustedViewControllerKey.title: "Apakah Anda mencoba masuk?",
            TrustedViewControllerKey.subtitle: "Seseorang mencoba masuk ke akun Anda dari perangkat lain.",
            TrustedViewControllerKey.buttonNo: "Tidak",
            TrustedViewControllerKey.buttonYes: "Iya",
            
            // MARK: - NonTrusted
            NonTrustedKey.title: "Setujui login ini dari ponsel Anda",
            NonTrustedKey.subtitle: "Pemberitahuan dikirim ke perangkat tepercaya Anda untuk mengonfirmasi itu adalah Anda.",
            
            // MARK: - QRScannerViewController
            QRScannerViewControllerKey.title: "Berhasil Mendaftarkan Perangkat Baru",
            QRScannerViewControllerKey.subtitle: "Anda sekarang dapat menggunakan perangkat baru untuk mengakses akun Anda tanpa persetujuan",
            
            // MARK: - RegisterTrustedViewController
            RegisterTrustedViewControllerKey.title: "Daftarkan Perangkat ini",
            RegisterTrustedViewControllerKey.subtitle: "Silakan pindai Kode QR ini dari Perangkat Tepercaya.",
            
            // MARK: - General Error Messages
            GeneralErrorMessagesKey.someWentWrong: "Ada Yang Salah",
            GeneralErrorMessagesKey.tryAgainLater: "Silakan coba lagi nanti.",
            GeneralErrorMessagesKey.requestTimeout: "Permintaan ini habis waktu. Silakan coba lagi nanti.",
            
            // MARK: - Pin Error Messages
            PinErrorMessagesKey.incorrectPinConfirmation: "Kamu perlu memasukkan PIN yang sama seperti sebelumnya.",
            PinErrorMessagesKey.badPin: "PIN terlalu mudah. Yuk buat PIN baru dengan kombinasi lebih sulit.",
            PinErrorMessagesKey.incorrectPinVerification: "PIN buat verifikasi salah. Coba lagi.",
            PinErrorMessagesKey.similarPinAsBefore: "PIN sama ama dulu punya. Coba ganti PIN baru.",
            PinErrorMessagesKey.incorrectEmailCode: "Kode yang kamu masukkan salah",
            PinErrorMessagesKey.enrollPinFailed: "PIN Registrasi gagal. Silahkan coba lagi.",
            PinErrorMessagesKey.updatePinFailed: "Membarui PIN gagal. Silahkan coba lagi.",
            PinErrorMessagesKey.resetPinFailed: "Atur ulang PIN gagal. Silahkan coba lagi.",
            PinErrorMessagesKey.unableToResetPin: "Tidak dapat melanjutkan dengan Reset Proses PIN.",
            PinErrorMessagesKey.networkError: "Coba periksa koneksi internet, terus coba lagi.",
            PinErrorMessagesKey.apiError: "Kesalahan dalam server. Silahkan hubungi layanan pelanggan.",
            PinErrorMessagesKey.serverError: "Kesalahan dalam server. Silahkan hubungi layanan pelanggan.",
            PinErrorMessagesKey.clientError: "Kesalahan dalam aplikasi. Mohon coba lagi nanti.",
            
            // MARK: - Trusted Devices Error Messages
            TrustedErrorMessagesKey.unableToContinue: "Tidak Dapat Melanjutkan dengan Proses Pendaftaran",
            TrustedErrorMessagesKey.deviceAlreadyReg: "Perangkat ini sudah terdaftar sebagai Perangkat Tepercaya!",
            TrustedErrorMessagesKey.deviceNotReg: "Perangkat ini tidak terdaftar sebagai Perangkat Tepercaya! Pemindaian harus dilakukan dari Perangkat Tepercaya.",
            TrustedErrorMessagesKey.unableToReg: "Tidak Dapat Mendaftarkan Perangkat Baru",
            
            // MARK: - Navigate Back Alert
            AuthAlertMessagesKey.navBackTitle: "Yakin tidak Mau Buat PIN Sekarang?",
            AuthAlertMessagesKey.navBackBody: "PIN Ini diperlukan untuk keamanan akunmu, lho.",
            AuthAlertMessagesKey.navBackActionButton: "Lain Kali",
            AuthAlertMessagesKey.navBackCancelButton: "Input PIN",
            
            // MARK: - Biometric Enrollment Authentication Alert
            AuthAlertMessagesKey.enrollAuthTitle: "Verifikasi",
            AuthAlertMessagesKey.enrollAuthBody: "Lanjutkan untuk menggunakan verifikasi TouchID atau FaceID",
            AuthAlertMessagesKey.enrollAuthActionButton: "",
            AuthAlertMessagesKey.enrollAuthCancelButton: "Gunakan PIN",
            
            // MARK: - Biometric Verification Authentication Alert
            AuthAlertMessagesKey.verifyAuthTitle: "Verifikasi",
            AuthAlertMessagesKey.verifyAuthBody: "Verifikasi biometrik Anda untuk melanjutkan",
            AuthAlertMessagesKey.verifyAuthActionButton: "",
            AuthAlertMessagesKey.verifyAuthCancelButton: "Gunakan PIN",
            
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
