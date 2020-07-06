// Generated using Sourcery 0.18.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT


// MARK: CotterEventRequest Equatable
extension CotterEventRequest: Equatable {
    public static func ==(lhs: CotterEventRequest, rhs: CotterEventRequest) -> Bool {
        guard lhs.pubKey == rhs.pubKey else { return false }
        guard lhs.userID == rhs.userID else { return false }
        guard lhs.issuer == rhs.issuer else { return false }
        guard lhs.event == rhs.event else { return false }
        guard lhs.ipAddr == rhs.ipAddr else { return false }
        guard lhs.location == rhs.location else { return false }
        guard lhs.timestamp == rhs.timestamp else { return false }
        guard lhs.authMethod == rhs.authMethod else { return false }
        guard lhs.code == rhs.code else { return false }
        guard lhs.approved == rhs.approved else { return false }
        guard lhs.registerNewDevice == rhs.registerNewDevice else { return false }
        guard lhs.newDevicePublicKey == rhs.newDevicePublicKey else { return false }
        guard lhs.deviceType == rhs.deviceType else { return false }
        guard lhs.deviceName == rhs.deviceName else { return false }
        guard lhs.newDeviceAlgo == rhs.newDeviceAlgo else { return false }
        return true
    }
}
// MARK: CreateAuthenticationEvent Equatable
extension CreateAuthenticationEvent: Equatable {
    public static func ==(lhs: CreateAuthenticationEvent, rhs: CreateAuthenticationEvent) -> Bool {
        guard lhs.method == rhs.method else { return false }
        guard lhs.evt == rhs.evt else { return false }
        guard lhs.oauth == rhs.oauth else { return false }
        return true
    }
}
// MARK: CreatePendingEventRequest Equatable
extension CreatePendingEventRequest: Equatable {
    public static func ==(lhs: CreatePendingEventRequest, rhs: CreatePendingEventRequest) -> Bool {
        guard lhs.method == rhs.method else { return false }
        guard lhs.event == rhs.event else { return false }
        return true
    }
}
// MARK: EnrollTrustedDevice Equatable
extension EnrollTrustedDevice: Equatable {
    public static func ==(lhs: EnrollTrustedDevice, rhs: EnrollTrustedDevice) -> Bool {
        guard lhs.method == rhs.method else { return false }
        guard lhs.code == rhs.code else { return false }
        guard lhs.clientUserID == rhs.clientUserID else { return false }
        guard lhs.cotterUserID == rhs.cotterUserID else { return false }
        return true
    }
}
// MARK: EnrollUserPIN Equatable
extension EnrollUserPIN: Equatable {
    public static func ==(lhs: EnrollUserPIN, rhs: EnrollUserPIN) -> Bool {
        guard lhs.method == rhs.method else { return false }
        guard lhs.code == rhs.code else { return false }
        guard lhs.userID == rhs.userID else { return false }
        return true
    }
}
// MARK: GetBiometricStatus Equatable
extension GetBiometricStatus: Equatable {
    public static func ==(lhs: GetBiometricStatus, rhs: GetBiometricStatus) -> Bool {
        guard lhs.method == rhs.method else { return false }
        guard lhs.pubKey == rhs.pubKey else { return false }
        guard lhs.userID == rhs.userID else { return false }
        return true
    }
}
// MARK: GetEvent Equatable
extension GetEvent: Equatable {
    public static func ==(lhs: GetEvent, rhs: GetEvent) -> Bool {
        guard lhs.method == rhs.method else { return false }
        guard lhs.eventID == rhs.eventID else { return false }
        return true
    }
}
// MARK: GetNewEvent Equatable
extension GetNewEvent: Equatable {
    public static func ==(lhs: GetNewEvent, rhs: GetNewEvent) -> Bool {
        guard lhs.method == rhs.method else { return false }
        guard lhs.userID == rhs.userID else { return false }
        return true
    }
}
// MARK: GetNotificationAppID Equatable
extension GetNotificationAppID: Equatable {
    internal static func ==(lhs: GetNotificationAppID, rhs: GetNotificationAppID) -> Bool {
        guard lhs.method == rhs.method else { return false }
        return true
    }
}
// MARK: GetTrustedDeviceEnrolledAny Equatable
extension GetTrustedDeviceEnrolledAny: Equatable {
    public static func ==(lhs: GetTrustedDeviceEnrolledAny, rhs: GetTrustedDeviceEnrolledAny) -> Bool {
        guard lhs.method == rhs.method else { return false }
        guard lhs.userID == rhs.userID else { return false }
        return true
    }
}
// MARK: GetTrustedDeviceStatus Equatable
extension GetTrustedDeviceStatus: Equatable {
    public static func ==(lhs: GetTrustedDeviceStatus, rhs: GetTrustedDeviceStatus) -> Bool {
        guard lhs.method == rhs.method else { return false }
        guard lhs.pubKey == rhs.pubKey else { return false }
        guard lhs.cotterUserID == rhs.cotterUserID else { return false }
        guard lhs.clientUserID == rhs.clientUserID else { return false }
        return true
    }
}
// MARK: GetUser Equatable
extension GetUser: Equatable {
    public static func ==(lhs: GetUser, rhs: GetUser) -> Bool {
        guard lhs.method == rhs.method else { return false }
        guard lhs.userID == rhs.userID else { return false }
        return true
    }
}
// MARK: RegisterBiometric Equatable
extension RegisterBiometric: Equatable {
    public static func ==(lhs: RegisterBiometric, rhs: RegisterBiometric) -> Bool {
        guard lhs.method == rhs.method else { return false }
        guard lhs.pubKey == rhs.pubKey else { return false }
        guard lhs.userID == rhs.userID else { return false }
        return true
    }
}
// MARK: RegisterUser Equatable
extension RegisterUser: Equatable {
    public static func ==(lhs: RegisterUser, rhs: RegisterUser) -> Bool {
        guard lhs.method == rhs.method else { return false }
        guard lhs.userID == rhs.userID else { return false }
        return true
    }
}
// MARK: RemoveTrustedDeviceStatus Equatable
extension RemoveTrustedDeviceStatus: Equatable {
    public static func ==(lhs: RemoveTrustedDeviceStatus, rhs: RemoveTrustedDeviceStatus) -> Bool {
        guard lhs.method == rhs.method else { return false }
        guard lhs.userID == rhs.userID else { return false }
        guard lhs.pubKey == rhs.pubKey else { return false }
        return true
    }
}
// MARK: RequestPINReset Equatable
extension RequestPINReset: Equatable {
    public static func ==(lhs: RequestPINReset, rhs: RequestPINReset) -> Bool {
        guard lhs.method == rhs.method else { return false }
        guard lhs.userID == rhs.userID else { return false }
        guard lhs.authMethod == rhs.authMethod else { return false }
        guard lhs.name == rhs.name else { return false }
        guard lhs.sendingMethod == rhs.sendingMethod else { return false }
        guard lhs.sendingDestination == rhs.sendingDestination else { return false }
        return true
    }
}
// MARK: RequestToken Equatable
extension RequestToken: Equatable {
    public static func ==(lhs: RequestToken, rhs: RequestToken) -> Bool {
        guard lhs.method == rhs.method else { return false }
        guard lhs.codeVerifier == rhs.codeVerifier else { return false }
        guard lhs.challengeID == rhs.challengeID else { return false }
        guard lhs.authorizationCode == rhs.authorizationCode else { return false }
        guard lhs.redirectURL == rhs.redirectURL else { return false }
        return true
    }
}
// MARK: ResetPIN Equatable
extension ResetPIN: Equatable {
    public static func ==(lhs: ResetPIN, rhs: ResetPIN) -> Bool {
        guard lhs.method == rhs.method else { return false }
        guard lhs.userID == rhs.userID else { return false }
        guard lhs.authMethod == rhs.authMethod else { return false }
        guard lhs.resetCode == rhs.resetCode else { return false }
        guard lhs.newCode == rhs.newCode else { return false }
        guard lhs.challengeID == rhs.challengeID else { return false }
        guard lhs.challenge == rhs.challenge else { return false }
        return true
    }
}
// MARK: RespondEvent Equatable
extension RespondEvent: Equatable {
    public static func ==(lhs: RespondEvent, rhs: RespondEvent) -> Bool {
        guard lhs.method == rhs.method else { return false }
        guard lhs.eventID == rhs.eventID else { return false }
        guard lhs.event == rhs.event else { return false }
        return true
    }
}
// MARK: UpdateBiometricStatus Equatable
extension UpdateBiometricStatus: Equatable {
    public static func ==(lhs: UpdateBiometricStatus, rhs: UpdateBiometricStatus) -> Bool {
        guard lhs.method == rhs.method else { return false }
        guard lhs.pubKey == rhs.pubKey else { return false }
        guard lhs.enroll == rhs.enroll else { return false }
        guard lhs.userID == rhs.userID else { return false }
        return true
    }
}
// MARK: UpdateUserPIN Equatable
extension UpdateUserPIN: Equatable {
    public static func ==(lhs: UpdateUserPIN, rhs: UpdateUserPIN) -> Bool {
        guard lhs.method == rhs.method else { return false }
        guard lhs.oldCode == rhs.oldCode else { return false }
        guard lhs.newCode == rhs.newCode else { return false }
        guard lhs.userID == rhs.userID else { return false }
        return true
    }
}
// MARK: VerifyPINResetCode Equatable
extension VerifyPINResetCode: Equatable {
    public static func ==(lhs: VerifyPINResetCode, rhs: VerifyPINResetCode) -> Bool {
        guard lhs.method == rhs.method else { return false }
        guard lhs.userID == rhs.userID else { return false }
        guard lhs.authMethod == rhs.authMethod else { return false }
        guard lhs.resetCode == rhs.resetCode else { return false }
        guard lhs.challengeID == rhs.challengeID else { return false }
        guard lhs.challenge == rhs.challenge else { return false }
        return true
    }
}
