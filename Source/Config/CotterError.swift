//
//  Error.swift
//  Cotter
//
//  Created by Albert Purnama on 2/9/20.
//

import Foundation

public enum CotterError: LocalizedError {
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

    public var errorDescription: String? {
        switch self {
        case let .server(message), let .general(message):
            return message
        default:
            return self.localizedDescription;
        }
    }
}
