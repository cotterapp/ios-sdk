//
//  ImageObject.swift
//  Cotter
//
//  Created by Raymond Andrie on 2/27/20.
//

import Foundation

struct ImageEntity {
    var path: String
    var bundle: Bundle
}

public class ImageObject: NSObject {
    public static let defaultImages = [
        "cotter-success-check",
        "cotter-failure-x",
        "cotter-fingerprint",
        "cotter-fingerprint-failed",
        "cotter-lapis-logo",
        "cotter-logo",
        "tap_device",
        "warning",
    ]
    
    // non constant image path, allowing change of path
    var image: [String: String]

    public override init() {
        // Set to defaults inititally
        self.image = [
            // MARK: - VC Image Definitions
            VCImageKey.pinSuccessImg: "cotter-success-check",
            VCImageKey.resetPinSuccessImg: "cotter-success-check",
            VCImageKey.logo: "cotter-logo",
            VCImageKey.nonTrustedPhoneTap: "tap_device",
            VCImageKey.nonTrustedPhoneTapFail: "warning",
            
            // MARK: - Alert Image Definitions
            AlertImageKey.promptVerificationImg: "cotter-fingerprint",
            AlertImageKey.successVerificationImg: "cotter-success-check",
            AlertImageKey.failureVerificationImg: "cotter-failure-x",
            AlertImageKey.failureBiometricImg: "cotter-fingerprint-failed",
        ]
    }
      
    public func setImage(for key: String, to value: String) {
        print("setting \(key) to \(value)")
        self.image[key] = value
    }
}
