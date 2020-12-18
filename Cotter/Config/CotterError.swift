//
//  Error.swift
//  Cotter
//
//  Created by Albert Purnama on 2/9/20.
//

import Foundation

public enum CotterError: Error {
    case keychainError(String)
    case biometricEnrollment
    case biometricVerification
    case verificationCancelled
    case auth(String)
    case passwordless(String)
    case trustedDevice(String)
    case encoding
    case decoding
    case status(code: Int)
    case server(message: String)
    case network
    case general(message: String)
}
