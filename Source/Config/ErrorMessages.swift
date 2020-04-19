//
//  PinErrorMessages.swift
//  CotterIOS
//
//  Created by Raymond Andrie on 2/8/20.
//

import Foundation

public class GeneralErrorMessagesKey {
    static let someWentWrong = "GeneralErrorMessagesKey/someWentWrong"
    static let tryAgainLater = "GeneralErrorMessagesKey/tryAgainLater"
    static let requestTimeout = "GeneralErrorMessagesKey/requestTimeout"
}

public class PinErrorMessagesKey {
    static let incorrectPinConfirmation = "PinErrorMessagesKey/incorrectPinConfirmation"
    static let badPin = "PinErrorMessagesKey/badPin"
    static let incorrectPinVerification = "PinErrorMessagesKey/incorrectPinVerification"
    static let incorrectEmailCode = "PinErrorMessagesKey/incorrectEmailCode"
    static let similarPinAsBefore = "PinErrorMessagesKey/similarPinAsBefore"
    static let enrollPinFailed = "PinErrorMessagesKey/enrollPinFailed"
    static let updatePinFailed = "PinErrorMessagesKey/updatePinFailed"
    static let unableToResetPin = "PinErrorMessagesKey/unableToResetPin"
    static let resetPinFailed = "PinErrorMessagesKey/resetPinFailed"
    static let networkError = "PinErrorMessagesKey/networkError"
    static let apiError = "PinErrorMessagesKey/apiError"
}

public class TrustedErrorMessagesKey {
    static let unableToContinue = "TrustedErrorMessagesKey/unableToContinue"
    static let deviceAlreadyReg = "TrustedErrorMessagesKey/deviceAlreadyReg"
    static let deviceNotReg = "TrustedErrorMessagesKey/deviceNotReg"
    static let unableToReg = "TrustedErrorMessagesKey/unableToReg"
}
