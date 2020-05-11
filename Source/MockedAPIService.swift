//
//  MockedAPIService.swift
//  Cotter
//
//  Created by Raymond Andrie on 5/11/20.
//

import Foundation

public struct MockedAPIServiceVariables {
    // MARK: - Mock Variables
    public let userID = "MOCK_USER_ID"
    public let name = "MOCK_NAME"
    public let pubKey = "MOCK_PUB_KEY"
    public let newPubKey = "MOCK_NEW_PUB_KEY"
    public let issuer = "MOCK_ISSUER"
    public let event = "MOCK_EVENT"
    public let ipAddr = "MOCK_IP_ADDR"
    public let location = "MOCK_LOCATION"
    public let oldCode = "MOCK_OLD_CODE"
    public let code = "MOCK_CODE"
    public let method = "MOCK_METHOD"
    public let enrolled = true
    public let approved = true
    public let notApproved = false
    public let timestamp = "MOCK_TIMESTAMP"
    public let codeVerifier = "MOCK_CODE_VERIFIER"
    public let challengeID = 1
    public let challenge = "MOCK_CHALLENGE"
    public let authorizationCode = "MOCK_AUTHORIZATION_CODE"
    public let redirectURL = "MOCK_REDIRECT_URL"
    public let signature = "MOCK_SIGNATURE"
    public let eventID = "MOCK_EVENT_ID"
    public let deviceType = "MOCK_DEVICE_TYPE"
    public let deviceName = "MOCK_DEVICE_NAME"
    public let deviceAlgo = "MOCK_DEVICE_ALGO"
    public let resetCode = "MOCK_RESET_CODE"
    public let sendingMethod = "MOCK_SENDING_METHOD"
    public let sendingDestination = "MOCK_SENDING_DESTINATION"
}

public class MockedAPIService: APIService {
    
    let mock = MockedAPIServiceVariables()
    
    // MARK: - CotterAPIService.auth function
    var authInputRequest: CreateAuthenticationEvent?
    var authCalled: Bool = false
    
    public func auth(userID: String, issuer: String, event: String, code: String, method: String, pubKey: String?, timestamp: String, cb: @escaping ResultCallback<CotterEvent>) -> Void {
        let evt = CotterEventRequest(
            pubKey: mock.pubKey,
            userID: userID,
            issuer: mock.issuer,
            event: event,
            ipAddr: mock.ipAddr,
            location: mock.location,
            timestamp: timestamp,
            authMethod: method,
            code: code,
            approved: mock.approved
        )
        authInputRequest = CreateAuthenticationEvent(evt: evt)
        authCalled = true
    }
    
    // MARK: - CotterAPIService.registerUser function
    var registerUserInputRequest: RegisterUser?
    var registerUserCalled: Bool = false

    public func registerUser(userID: String, cb: @escaping ResultCallback<CotterUser>) -> Void {
        registerUserInputRequest = RegisterUser(userID: userID)
        registerUserCalled = true
    }
    
    // MARK: - CotterAPIService.enrollUserPIN function
    var enrollUserPinInputRequest: EnrollUserPIN?
    var enrollUserPinCalled: Bool = false

    public func enrollUserPin(code: String, cb: @escaping ResultCallback<CotterUser>) -> Void {
        enrollUserPinInputRequest = EnrollUserPIN(userID: mock.userID, code: code)
        enrollUserPinCalled = true
    }
    
    // MARK: - CotterAPIService.updateUserPIN function
    var updateUserPinInputRequest: UpdateUserPIN?
    var updateUserPinCalled: Bool = false

    public func updateUserPin(oldCode: String, newCode: String, cb: @escaping ResultCallback<CotterUser>) -> Void {
        updateUserPinInputRequest = UpdateUserPIN(userID: mock.userID, newCode: newCode, oldCode: oldCode)
        updateUserPinCalled = true
    }
    
    // MARK: - CotterAPIService.getBiometricStatus function
    var getBiometricStatusInputRequest: GetBiometricStatus?
    var getBiometricStatusCalled: Bool = false

    public func getBiometricStatus(cb: @escaping ResultCallback<EnrolledMethods>) -> Void {
        getBiometricStatusInputRequest = GetBiometricStatus(userID: mock.userID, pubKey: mock.pubKey)
        getBiometricStatusCalled = true
    }
    
    // MARK: - CotterAPIService.updateBiometricStatus function
    var updateBiometricStatusInputRequest: UpdateBiometricStatus?
    var updateBiometricStatusCalled: Bool = false

    public func updateBiometricStatus(enrollBiometric: Bool, cb: @escaping ResultCallback<CotterUser>) -> Void {
        updateBiometricStatusInputRequest = UpdateBiometricStatus(userID: mock.userID, enroll: enrollBiometric, pubKey: mock.pubKey)
        updateBiometricStatusCalled = true
    }
    
    // MARK: - CotterAPIService.requestToken function
    var requestTokenInputRequest: RequestToken?
    var requestTokenCalled: Bool = false

    public func requestToken(codeVerifier: String, challengeID: Int, authorizationCode: String, redirectURL: String, cb: @escaping ResultCallback<CotterIdentity>) -> Void {
        requestTokenInputRequest = RequestToken(codeVerifier: codeVerifier, challengeID: challengeID, authorizationCode: authorizationCode, redirectURL: redirectURL)
        requestTokenCalled = true
    }
    
    // MARK: - CotterAPIService.getUser function
    var getUserInputRequest: GetUser?
    var getUserCalled: Bool = false

    public func getUser(userID: String, cb: @escaping ResultCallback<CotterUser>) -> Void {
        getUserInputRequest = GetUser(userID: userID)
        getUserCalled = true
    }
    
    // MARK: - CotterAPIService.registerBiometric function
    var registerBiometricInputRequest: RegisterBiometric?
    var registerBiometricCalled: Bool = false

    public func registerBiometric(userID: String, pubKey: String, cb: @escaping ResultCallback<CotterUser>) -> Void {
        registerBiometricInputRequest = RegisterBiometric(userID: userID, pubKey: pubKey)
        registerBiometricCalled = true
    }
    
    // MARK: - CotterAPIService.requestPINReset function
    var requestPINResetRequest: RequestPINReset?
    var requestPINResetCalled: Bool = false

    public func requestPINReset(name: String, sendingMethod: String, sendingDestination: String, cb: @escaping ResultCallback<CotterResponseWithChallenge>) -> Void {
        requestPINResetRequest = RequestPINReset(userID: mock.userID, name: name, sendingMethod: sendingMethod, sendingDestination: sendingDestination)
        requestPINResetCalled = true
    }
    
    // MARK: - CotterAPIService.verifyPINResetCode function
    var verifyPINResetCodeInputRequest: VerifyPINResetCode?
    var verifyPINResetCodeCalled: Bool = false

    public func verifyPINResetCode(resetCode: String, challengeID: Int, challenge: String, cb: @escaping ResultCallback<CotterBasicResponse>) -> Void {
        verifyPINResetCodeInputRequest = VerifyPINResetCode(userID: mock.userID, resetCode: resetCode, challengeID: challengeID, challenge: challenge)
        verifyPINResetCodeCalled = true
    }
    
    // MARK: - CotterAPIService.resetPIN function
    var resetPINInputRequest: ResetPIN?
    var resetPINCalled: Bool = false

    public func resetPIN(resetCode: String, newCode: String, challengeID: Int, challenge: String, cb: @escaping ResultCallback<CotterBasicResponse>) -> Void {
        resetPINInputRequest = ResetPIN(userID: mock.userID, resetCode: resetCode, newCode: newCode, challengeID: challengeID, challenge: challenge)
        resetPINCalled = true
    }
    
    // MARK: - CotterAPIService.enrollTrustedDevice function
    var enrollTrustedDeviceInputRequest: EnrollTrustedDevice?
    var enrollTrustedDeviceCalled: Bool = false

    public func enrollTrustedDevice(userID: String, cb: @escaping ResultCallback<CotterUser>) -> Void {
        enrollTrustedDeviceInputRequest = EnrollTrustedDevice(userID: userID, code: mock.pubKey)
        enrollTrustedDeviceCalled = true
    }
    
    // MARK: - CotterAPIService.getNewEvent function
    var getNewEventInputRequest: GetNewEvent?
    var getNewEventCalled: Bool = false

    public func getNewEvent(userID: String, cb: @escaping ResultCallback<CotterEvent?>) -> Void {
        getNewEventInputRequest = GetNewEvent(userID: userID)
        getNewEventCalled = true
    }
    
    // MARK: - CotterAPIService.getTrustedDeviceStatus function
    var getTrustedDeviceStatusInputRequest: GetTrustedDeviceStatus?
    var getTrustedDeviceStatusCalled: Bool = false

    public func getTrustedDeviceStatus(userID: String, cb: @escaping ResultCallback<EnrolledMethods>) -> Void {
        getTrustedDeviceStatusInputRequest = GetTrustedDeviceStatus(userID: userID, pubKey: mock.pubKey)
        getTrustedDeviceStatusCalled = true
    }
    
    // MARK: - CotterAPIService.getTrustedDeviceEnrolledAny function
    var getTrustedDeviceEnrolledAnyInputRequest: GetTrustedDeviceEnrolledAny?
    var getTrustedDeviceEnrolledAnyCalled: Bool = false

    public func getTrustedDeviceEnrolledAny(userID: String, cb: @escaping ResultCallback<EnrolledMethods>) -> Void {
        getTrustedDeviceEnrolledAnyInputRequest = GetTrustedDeviceEnrolledAny(userID: userID)
        getTrustedDeviceEnrolledAnyCalled = true
    }
    
    // MARK: - CotterAPIService.reqAuth function
    var reqAuthInputRequest: CreatePendingEventRequest?
    var reqAuthCalled: Bool = false

    public func reqAuth(userID: String, event: String, cb: @escaping ResultCallback<CotterEvent>) -> Void {
        let evt = CotterEventRequest(
            pubKey: mock.pubKey,
            userID: userID,
            issuer: mock.issuer,
            event: event,
            ipAddr: mock.ipAddr,
            location: mock.location,
            timestamp: mock.timestamp,
            authMethod: mock.method,
            code: nil,
            approved: mock.notApproved
        )
        reqAuthInputRequest = CreatePendingEventRequest(evt: evt)
        reqAuthCalled = true
    }
    
    // MARK: - CotterAPIService.getEventCalled function
    var getEventInputRequest: GetEvent?
    var getEventCalled: Bool = false

    public func getEvent(eventID: String, cb: @escaping ResultCallback<CotterEvent>) -> Void {
        getEventInputRequest = GetEvent(eventID: eventID)
        getEventCalled = true
    }
    
    // MARK: - CotterAPIService.approveEvent function
    var approveEventInputRequest: RespondEvent?
    var approveEventCalled: Bool = false

    public func approveEvent(event: CotterEvent, cb: @escaping ResultCallback<CotterEvent>) -> Void {
        let evt = CotterEventRequest(
            pubKey: mock.pubKey,
            userID: event.clientUserID,
            issuer: mock.issuer,
            event: event.event,
            ipAddr: event.ip,
            location: event.location,
            timestamp: event.timestamp,
            authMethod: event.method,
            code: mock.signature,
            approved: mock.approved
        )
        approveEventInputRequest = RespondEvent(evtID: mock.eventID, evt: evt)
        approveEventCalled = true
    }
    
    // MARK: - CotterAPIService.registerOtherDevice function
    var registerOtherDeviceInputRequest: CreateAuthenticationEvent?
    var registerOtherDeviceCalled: Bool = false

    public func registerOtherDevice(qrData:String, userID:String, cb: @escaping ResultCallback<CotterEvent>) -> Void {
        let evt = CotterEventRequest(
            pubKey: mock.pubKey,
            userID: userID,
            issuer: mock.issuer,
            event: mock.event,
            ipAddr: mock.ipAddr,
            location: mock.location,
            timestamp: mock.timestamp,
            authMethod: mock.method,
            code: mock.signature,
            approved: mock.approved,
            registerNewDevice: true,
            newDevicePublicKey: mock.newPubKey,
            // TODO: get device type and name
            deviceType: mock.deviceType,
            deviceName: mock.deviceName,
            newDeviceAlgo: mock.deviceAlgo
        )
        registerOtherDeviceInputRequest = CreateAuthenticationEvent(evt: evt, oauth: true)
        registerOtherDeviceCalled = true
    }
    
    // MARK: - CotterAPIService.removeTrustedDeviceStatus function
    var removeTrustedDeviceStatusInputRequest: RemoveTrustedDeviceStatus?
    var removeTrustedDeviceStatusCalled: Bool = false
    
    public func removeTrustedDeviceStatus(userID: String, cb: @escaping ResultCallback<CotterUser>) -> Void {
        removeTrustedDeviceStatusInputRequest = RemoveTrustedDeviceStatus(userID: userID, pubKey: mock.pubKey)
        removeTrustedDeviceStatusCalled = true
    }
    
    // MARK: - CotterAPIService.getNotificationAppID function
    var getNotificationAppIDInputRequest: GetNotificationAppID?
    var getNotificationAppIDCalled: Bool = false

    public func getNotificationAppID(cb: @escaping ResultCallback<CotterNotificationCredential>) -> Void {
        getNotificationAppIDInputRequest = GetNotificationAppID()
        getNotificationAppIDCalled = true
    }
}
