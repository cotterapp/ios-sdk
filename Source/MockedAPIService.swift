//
//  MockedAPIService.swift
//  Cotter
//
//  Created by Raymond Andrie on 5/11/20.
//

import Foundation

public class MockedAPIService: APIService {
    
    let mock = MockAPIServiceVariables()
    let mockedClient = MockedCotterClient()
    
    // MARK: - CotterAPIService.auth function
    var authInputRequest: CreateAuthenticationEvent!
    var authCalled: Bool = false
    
    public func auth(userID: String, issuer: String, event: String, code: String, method: String, pubKey: String?, timestamp: String, cb: @escaping ResultCallback<CotterEvent>) -> Void {
        let evt = CotterEventRequest(
            pubKey: mock.publicKey,
            userID: userID,
            issuer: mock.issuer,
            event: event,
            ipAddr: mock.ip,
            location: mock.location,
            timestamp: timestamp,
            authMethod: method,
            code: code,
            approved: mock.approved
        )
        authInputRequest = CreateAuthenticationEvent(evt: evt)
        authCalled = true
 
        mockedClient.send(authInputRequest) { response in
            cb(response)
        }
    }
    
    // MARK: - CotterAPIService.registerUser function
    var registerUserInputRequest: RegisterUser!
    var registerUserCalled: Bool = false

    public func registerUser(userID: String, cb: @escaping ResultCallback<CotterUser>) -> Void {
        registerUserInputRequest = RegisterUser(userID: userID)
        registerUserCalled = true
        
        mockedClient.send(registerUserInputRequest) { response in
            cb(response)
        }
    }
    
    // MARK: - CotterAPIService.enrollUserPIN function
    var enrollUserPinInputRequest: EnrollUserPIN!
    var enrollUserPinCalled: Bool = false

    public func enrollUserPin(code: String, cb: @escaping ResultCallback<CotterUser>) -> Void {
        enrollUserPinInputRequest = EnrollUserPIN(userID: mock.userID, code: code)
        enrollUserPinCalled = true
        
        mockedClient.send(enrollUserPinInputRequest) { response in
            cb(response)
        }
    }
    
    // MARK: - CotterAPIService.updateUserPIN function
    var updateUserPinInputRequest: UpdateUserPIN!
    var updateUserPinCalled: Bool = false

    public func updateUserPin(oldCode: String, newCode: String, cb: @escaping ResultCallback<CotterUser>) -> Void {
        updateUserPinInputRequest = UpdateUserPIN(userID: mock.userID, newCode: newCode, oldCode: oldCode)
        updateUserPinCalled = true
        
        mockedClient.send(updateUserPinInputRequest) { response in
            cb(response)
        }
    }
    
    // MARK: - CotterAPIService.getBiometricStatus function
    var getBiometricStatusInputRequest: GetBiometricStatus!
    var getBiometricStatusCalled: Bool = false

    public func getBiometricStatus(cb: @escaping ResultCallback<EnrolledMethods>) -> Void {
        getBiometricStatusInputRequest = GetBiometricStatus(userID: mock.userID, pubKey: mock.publicKey)
        getBiometricStatusCalled = true
        
        mockedClient.send(getBiometricStatusInputRequest) { response in
            cb(response)
        }
    }
    
    // MARK: - CotterAPIService.updateBiometricStatus function
    var updateBiometricStatusInputRequest: UpdateBiometricStatus!
    var updateBiometricStatusCalled: Bool = false

    public func updateBiometricStatus(enrollBiometric: Bool, cb: @escaping ResultCallback<CotterUser>) -> Void {
        updateBiometricStatusInputRequest = UpdateBiometricStatus(userID: mock.userID, enroll: enrollBiometric, pubKey: mock.publicKey)
        updateBiometricStatusCalled = true
        
        mockedClient.send(updateBiometricStatusInputRequest) { response in
            cb(response)
        }
    }
    
    // MARK: - CotterAPIService.requestToken function
    var requestTokenInputRequest: RequestToken!
    var requestTokenCalled: Bool = false

    public func requestToken(codeVerifier: String, challengeID: Int, authorizationCode: String, redirectURL: String, cb: @escaping ResultCallback<CotterIdentity>) -> Void {
        requestTokenInputRequest = RequestToken(codeVerifier: codeVerifier, challengeID: challengeID, authorizationCode: authorizationCode, redirectURL: redirectURL)
        requestTokenCalled = true
        
        mockedClient.send(requestTokenInputRequest) { response in
            cb(response)
        }
    }
    
    // MARK: - CotterAPIService.getUser function
    var getUserInputRequest: GetUser!
    var getUserCalled: Bool = false

    public func getUser(userID: String, cb: @escaping ResultCallback<CotterUser>) -> Void {
        getUserInputRequest = GetUser(userID: userID)
        getUserCalled = true
        
        mockedClient.send(getUserInputRequest) { response in
            cb(response)
        }
    }
    
    // MARK: - CotterAPIService.registerBiometric function
    var registerBiometricInputRequest: RegisterBiometric!
    var registerBiometricCalled: Bool = false

    public func registerBiometric(userID: String, pubKey: String, cb: @escaping ResultCallback<CotterUser>) -> Void {
        registerBiometricInputRequest = RegisterBiometric(userID: userID, pubKey: pubKey)
        registerBiometricCalled = true
        
        mockedClient.send(registerBiometricInputRequest) { response in
            cb(response)
        }
    }
    
    // MARK: - CotterAPIService.requestPINReset function
    var requestPINResetRequest: RequestPINReset!
    var requestPINResetCalled: Bool = false

    public func requestPINReset(name: String, sendingMethod: String, sendingDestination: String, cb: @escaping ResultCallback<CotterResponseWithChallenge>) -> Void {
        requestPINResetRequest = RequestPINReset(userID: mock.userID, name: name, sendingMethod: sendingMethod, sendingDestination: sendingDestination)
        requestPINResetCalled = true
        
        mockedClient.send(requestPINResetRequest) { response in
            cb(response)
        }
    }
    
    // MARK: - CotterAPIService.verifyPINResetCode function
    var verifyPINResetCodeInputRequest: VerifyPINResetCode!
    var verifyPINResetCodeCalled: Bool = false

    public func verifyPINResetCode(resetCode: String, challengeID: Int, challenge: String, cb: @escaping ResultCallback<CotterBasicResponse>) -> Void {
        verifyPINResetCodeInputRequest = VerifyPINResetCode(userID: mock.userID, resetCode: resetCode, challengeID: challengeID, challenge: challenge)
        verifyPINResetCodeCalled = true
        
        mockedClient.send(verifyPINResetCodeInputRequest) { response in
            cb(response)
        }
    }
    
    // MARK: - CotterAPIService.resetPIN function
    var resetPINInputRequest: ResetPIN!
    var resetPINCalled: Bool = false

    public func resetPIN(resetCode: String, newCode: String, challengeID: Int, challenge: String, cb: @escaping ResultCallback<CotterBasicResponse>) -> Void {
        resetPINInputRequest = ResetPIN(userID: mock.userID, resetCode: resetCode, newCode: newCode, challengeID: challengeID, challenge: challenge)
        resetPINCalled = true
        
        mockedClient.send(resetPINInputRequest) { response in
            cb(response)
        }
    }
    
    // MARK: - CotterAPIService.enrollTrustedDevice function
    var enrollTrustedDeviceInputRequest: EnrollTrustedDevice!
    var enrollTrustedDeviceCalled: Bool = false

    public func enrollTrustedDevice(clientUserID: String, cb: @escaping ResultCallback<CotterUser>) -> Void {
        enrollTrustedDeviceInputRequest = EnrollTrustedDevice(clientUserID: clientUserID, code: mock.publicKey)
        enrollTrustedDeviceCalled = true
        
        mockedClient.send(enrollTrustedDeviceInputRequest) { response in
            cb(response)
        }
    }
    
    // MARK: - CotterAPIService.enrollTrustedDeviceWith function
    var enrollTrustedDeviceWithInputRequest: EnrollTrustedDevice!
    var enrollTrustedDeviceWithCalled: Bool = false

    public func enrollTrustedDeviceWith(cotterUser: CotterUser, cb: @escaping ResultCallback<CotterUser>) -> Void {
        enrollTrustedDeviceWithInputRequest = EnrollTrustedDevice(cotterUserID: cotterUser.id, code: mock.publicKey)
        enrollTrustedDeviceWithCalled = true
        
        mockedClient.send(enrollTrustedDeviceWithInputRequest) { response in
            cb(response)
        }
    }
    
    // MARK: - CotterAPIService.getNewEvent function
    var getNewEventInputRequest: GetNewEvent!
    var getNewEventCalled: Bool = false

    public func getNewEvent(userID: String, cb: @escaping ResultCallback<CotterEvent?>) -> Void {
        getNewEventInputRequest = GetNewEvent(userID: userID)
        getNewEventCalled = true
        
        mockedClient.send(getNewEventInputRequest) { response in
            cb(response)
        }
    }
    
    // MARK: - CotterAPIService.getTrustedDeviceStatus function
    var getTrustedDeviceStatusInputRequest: GetTrustedDeviceStatus!
    var getTrustedDeviceStatusCalled: Bool = false

    public func getTrustedDeviceStatus(clientUserID: String, cb: @escaping ResultCallback<EnrolledMethods>) -> Void {
        getTrustedDeviceStatusInputRequest = GetTrustedDeviceStatus(clientUserID: clientUserID, pubKey: mock.publicKey)
        getTrustedDeviceStatusCalled = true
        
        mockedClient.send(getTrustedDeviceStatusInputRequest) { response in
            cb(response)
        }
    }
    
    // MARK: - CotterAPIService.getTrustedDeviceStatusWith function
    var getTrustedDeviceStatusWithInputRequest: GetTrustedDeviceStatus!
    var getTrustedDeviceStatusWithCalled: Bool = false

    public func getTrustedDeviceStatusWith(cotterUserID: String, cb: @escaping ResultCallback<EnrolledMethods>) -> Void {
        getTrustedDeviceStatusWithInputRequest = GetTrustedDeviceStatus(cotterUserID: cotterUserID, pubKey: mock.publicKey)
        getTrustedDeviceStatusWithCalled = true
        
        mockedClient.send(getTrustedDeviceStatusWithInputRequest) { response in
            cb(response)
        }
    }
    
    // MARK: - CotterAPIService.getTrustedDeviceEnrolledAny function
    var getTrustedDeviceEnrolledAnyInputRequest: GetTrustedDeviceEnrolledAny!
    var getTrustedDeviceEnrolledAnyCalled: Bool = false

    public func getTrustedDeviceEnrolledAny(userID: String, cb: @escaping ResultCallback<EnrolledMethods>) -> Void {
        getTrustedDeviceEnrolledAnyInputRequest = GetTrustedDeviceEnrolledAny(userID: userID)
        getTrustedDeviceEnrolledAnyCalled = true
        
        mockedClient.send(getTrustedDeviceEnrolledAnyInputRequest) { response in
            cb(response)
        }
    }
    
    // MARK: - CotterAPIService.reqAuth function
    var reqAuthInputRequest: CreatePendingEventRequest!
    var reqAuthCalled: Bool = false

    public func reqAuth(clientUserID: String, event: String, cb: @escaping ResultCallback<CotterEvent>) -> Void {
        let evt = CotterEventRequest(
            pubKey: mock.publicKey,
            userID: clientUserID,
            issuer: mock.issuer,
            event: event,
            ipAddr: mock.ip,
            location: mock.location,
            timestamp: mock.timestamp,
            authMethod: mock.method,
            code: nil,
            approved: mock.approved
        )
        reqAuthInputRequest = CreatePendingEventRequest(evt: evt)
        reqAuthCalled = true
        
        mockedClient.send(reqAuthInputRequest) { response in
            cb(response)
        }
    }
    
    // MARK: - CotterAPIService.reqAuthWith function
    var reqAuthWithInputRequest: CreatePendingEventRequest!
    var reqAuthWithCalled: Bool = false

    public func reqAuthWith(cotterUserID: String, event: String, cb: @escaping ResultCallback<CotterEvent>) -> Void {
        let evt = CotterEventRequest(
            pubKey: mock.publicKey,
            userID: cotterUserID,
            issuer: mock.issuer,
            event: event,
            ipAddr: mock.ip,
            location: mock.location,
            timestamp: mock.timestamp,
            authMethod: mock.method,
            code: nil,
            approved: mock.approved
        )
        reqAuthWithInputRequest = CreatePendingEventRequest(evt: evt)
        reqAuthWithCalled = true
        
        mockedClient.send(reqAuthWithInputRequest) { response in
            cb(response)
        }
    }
    
    // MARK: - CotterAPIService.getEventCalled function
    var getEventInputRequest: GetEvent!
    var getEventCalled: Bool = false

    public func getEvent(eventID: String, cb: @escaping ResultCallback<CotterEvent>) -> Void {
        getEventInputRequest = GetEvent(eventID: eventID)
        getEventCalled = true
        
        mockedClient.send(getEventInputRequest) { response in
            cb(response)
        }
    }
    
    // MARK: - CotterAPIService.approveEvent function
    var approveEventInputRequest: RespondEvent!
    var approveEventCalled: Bool = false

    public func approveEvent(event: CotterEvent, cb: @escaping ResultCallback<CotterEvent>) -> Void {
        let evt = CotterEventRequest(
            pubKey: mock.publicKey,
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
        
        mockedClient.send(approveEventInputRequest) { response in
            cb(response)
        }
    }
    
    // MARK: - CotterAPIService.registerOtherDevice function
    var registerOtherDeviceInputRequest: CreateAuthenticationEvent!
    var registerOtherDeviceCalled: Bool = false

    public func registerOtherDevice(qrData:String, userID:String, cb: @escaping ResultCallback<CotterEvent>) -> Void {
        let evt = CotterEventRequest(
            pubKey: mock.publicKey,
            userID: userID,
            issuer: mock.issuer,
            event: mock.event,
            ipAddr: mock.ip,
            location: mock.location,
            timestamp: mock.timestamp,
            authMethod: mock.method,
            code: mock.signature,
            approved: mock.approved,
            registerNewDevice: true,
            newDevicePublicKey: mock.newPublicKey,
            // TODO: get device type and name
            deviceType: mock.deviceType,
            deviceName: mock.deviceName,
            newDeviceAlgo: mock.deviceAlgo
        )
        registerOtherDeviceInputRequest = CreateAuthenticationEvent(evt: evt, oauth: true)
        registerOtherDeviceCalled = true
        
        mockedClient.send(registerOtherDeviceInputRequest) { response in
            cb(response)
        }
    }
    
    // MARK: - CotterAPIService.removeTrustedDeviceStatus function
    var removeTrustedDeviceStatusInputRequest: RemoveTrustedDeviceStatus!
    var removeTrustedDeviceStatusCalled: Bool = false
    
    public func removeTrustedDeviceStatus(userID: String, cb: @escaping ResultCallback<CotterUser>) -> Void {
        removeTrustedDeviceStatusInputRequest = RemoveTrustedDeviceStatus(userID: userID, pubKey: mock.publicKey)
        removeTrustedDeviceStatusCalled = true
        
        mockedClient.send(removeTrustedDeviceStatusInputRequest) { response in
            cb(response)
        }
    }
    
    // MARK: - CotterAPIService.getNotificationAppID function
    var getNotificationAppIDInputRequest: GetNotificationAppID!
    var getNotificationAppIDCalled: Bool = false

    public func getNotificationAppID(cb: @escaping ResultCallback<CotterNotificationCredential>) -> Void {
        getNotificationAppIDInputRequest = GetNotificationAppID()
        getNotificationAppIDCalled = true
        
        mockedClient.send(getNotificationAppIDInputRequest) { response in
            cb(response)
        }
    }
}
