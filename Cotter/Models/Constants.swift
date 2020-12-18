//
//  Constants.swift
//  Cotter
//
//  Created by Albert Purnama on 2/29/20.
//

import Foundation

public struct CotterMethods {
    // MARK: - List of Verification Methods
    public static let Pin = "PIN"
    public static let Biometric = "BIOMETRIC"
    public static let TrustedDevice = "TRUSTED_DEVICE"
    
    // MARK: - List of Sending Methods
    public static let Email = "EMAIL"
    public static let Phone = "PHONE"
}

public struct CotterEvents {
    // MARK: - List of Events
    public static let EnrollNewTrustedDevice = "ENROLL_NEW_TRUSTED_DEVICE"
    public static let RequestAuthManual = "REQUEST_AUTH_MANUAL"
    public static let Transaction = "TRANSACTION"
    public static let Update = "UPDATE"
    public static let Login = "LOGIN"
}
