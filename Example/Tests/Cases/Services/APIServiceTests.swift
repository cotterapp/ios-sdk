//
//  APIServiceTests.swift
//  CotterIOS_Tests
//
//  Created by Raymond Andrie on 5/10/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import XCTest
import Nimble
@testable import Cotter

class APIServiceTests: XCTestCase {

    let mockAPIService = MockedAPIService()
    let mock = MockedAPIServiceVariables()

    func testAuthCalled() {
        mockAPIService.auth(
            userID: mock.userID,
            issuer: mock.issuer,
            event: mock.event,
            code: mock.code,
            method: mock.method,
            pubKey: mock.pubKey,
            timestamp: mock.timestamp
        ) { _ in }

        let evt = CotterEventRequest(
            pubKey: mock.pubKey,
            userID: mock.userID,
            issuer: mock.issuer,
            event: mock.event,
            ipAddr: mock.ipAddr,
            location: mock.location,
            timestamp: mock.timestamp,
            authMethod: mock.method,
            code: mock.code,
            approved: mock.approved
        )
        let req = CreateAuthenticationEvent(evt: evt)
        
        expect(self.mockAPIService.authCalled).to(beTrue())
        expect(self.mockAPIService.authInputRequest).to(equal(req))
    }

    func testRegisterUser() {
        mockAPIService.registerUser(userID: mock.userID) { _ in }

        let req = RegisterUser(userID: mock.userID)
        
        expect(self.mockAPIService.registerUserCalled).to(beTrue())
        expect(self.mockAPIService.registerUserInputRequest).to(equal(req))
    }

    func testEnrollUserPin() {
        mockAPIService.enrollUserPin(code: mock.code) { _ in }

        let req = EnrollUserPIN(userID: mock.userID, code: mock.code)
        
        expect(self.mockAPIService.enrollUserPinCalled).to(beTrue())
        expect(self.mockAPIService.enrollUserPinInputRequest).to(equal(req))
    }

    func testUpdateUserPin() {
        mockAPIService.updateUserPin(oldCode: mock.oldCode, newCode: mock.code) { _ in }

        let req = UpdateUserPIN(userID: mock.userID, newCode: mock.code, oldCode: mock.oldCode)
        
        expect(self.mockAPIService.updateUserPinCalled).to(beTrue())
        expect(self.mockAPIService.updateUserPinInputRequest).to(equal(req))
    }

    func testGetBiometricStatus() {
        mockAPIService.getBiometricStatus() { _ in }

        let req = GetBiometricStatus(userID: mock.userID, pubKey: mock.pubKey)
        
        expect(self.mockAPIService.getBiometricStatusCalled).to(beTrue())
        expect(self.mockAPIService.getBiometricStatusInputRequest).to(equal(req))
    }

    func testUpdateBiometricStatus() {
        mockAPIService.updateBiometricStatus(enrollBiometric: mock.enrolled) { _ in }

        let req = UpdateBiometricStatus(userID: mock.userID, enroll: mock.enrolled, pubKey: mock.pubKey)
        
        expect(self.mockAPIService.updateBiometricStatusCalled).to(beTrue())
        expect(self.mockAPIService.updateBiometricStatusInputRequest).to(equal(req))
    }

    func testRequestToken() {
        mockAPIService.requestToken(codeVerifier: mock.codeVerifier, challengeID: mock.challengeID, authorizationCode: mock.authorizationCode, redirectURL: mock.redirectURL) { _ in }

        let req = RequestToken(codeVerifier: mock.codeVerifier, challengeID: mock.challengeID, authorizationCode: mock.authorizationCode, redirectURL: mock.redirectURL)

        expect(self.mockAPIService.requestTokenCalled).to(beTrue())
        expect(self.mockAPIService.requestTokenInputRequest).to(equal(req))
    }
    
    func testGetUser() {
        mockAPIService.getUser(userID: mock.userID) { _ in }
        
        let req = GetUser(userID: mock.userID)
        
        expect(self.mockAPIService.getUserCalled).to(beTrue())
        expect(self.mockAPIService.getUserInputRequest).to(equal(req))
    }
    
    func testRegisterBiometric() {
        mockAPIService.registerBiometric(userID: mock.userID, pubKey: mock.pubKey) { _ in }
        
        let req = RegisterBiometric(userID: mock.userID, pubKey: mock.pubKey)
        
        expect(self.mockAPIService.registerBiometricCalled).to(beTrue())
        expect(self.mockAPIService.registerBiometricInputRequest).to(equal(req))
    }
    
    func testRequestPINReset() {
        mockAPIService.requestPINReset(name: mock.name, sendingMethod: mock.sendingMethod, sendingDestination: mock.sendingDestination) { _ in }
        
        let req = RequestPINReset(userID: mock.userID, name: mock.name, sendingMethod: mock.sendingMethod, sendingDestination: mock.sendingDestination)
        
        expect(self.mockAPIService.requestPINResetCalled).to(beTrue())
        expect(self.mockAPIService.requestPINResetRequest).to(equal(req))
    }
    
    func testVerifyPINResetCode() {
        mockAPIService.verifyPINResetCode(resetCode: mock.resetCode, challengeID: mock.challengeID, challenge: mock.challenge) { _ in }
        
        let req = VerifyPINResetCode(userID: mock.userID, resetCode: mock.resetCode, challengeID: mock.challengeID, challenge: mock.challenge)
        
        expect(self.mockAPIService.verifyPINResetCodeCalled).to(beTrue())
        expect(self.mockAPIService.verifyPINResetCodeInputRequest).to(equal(req))
    }
    
    func testResetPIN() {
        mockAPIService.resetPIN(resetCode: mock.resetCode, newCode: mock.code, challengeID: mock.challengeID, challenge: mock.challenge) { _ in }
        
        let req = ResetPIN(userID: mock.userID, resetCode: mock.resetCode, newCode: mock.code, challengeID: mock.challengeID, challenge: mock.challenge)
        
        expect(self.mockAPIService.resetPINCalled).to(beTrue())
        expect(self.mockAPIService.resetPINInputRequest).to(equal(req))
    }
    
    func testEnrollTrustedDevice() {
        mockAPIService.enrollTrustedDevice(userID: mock.userID) { _ in }
        
        let req = EnrollTrustedDevice(userID: mock.userID, code: mock.pubKey)
        
        expect(self.mockAPIService.enrollTrustedDeviceCalled).to(beTrue())
        expect(self.mockAPIService.enrollTrustedDeviceInputRequest).to(equal(req))
    }
    
    func testGetNewEvent() {
        mockAPIService.getNewEvent(userID: mock.userID) { _ in }
        
        let req = GetNewEvent(userID: mock.userID)
        
        expect(self.mockAPIService.getNewEventCalled).to(beTrue())
        expect(self.mockAPIService.getNewEventInputRequest).to(equal(req))
    }
    
    func testGetTrustedDeviceStatus() {
        mockAPIService.getTrustedDeviceStatus(userID: mock.userID) { _ in }
        
        let req = GetTrustedDeviceStatus(userID: mock.userID, pubKey: mock.pubKey)
        
        expect(self.mockAPIService.getTrustedDeviceStatusCalled).to(beTrue())
        expect(self.mockAPIService.getTrustedDeviceStatusInputRequest).to(equal(req))
    }
    
    func testGetTrustedDeviceEnrolledAny() {
        mockAPIService.getTrustedDeviceEnrolledAny(userID: mock.userID) { _ in }
        
        let req = GetTrustedDeviceEnrolledAny(userID: mock.userID)
        
        expect(self.mockAPIService.getTrustedDeviceEnrolledAnyCalled).to(beTrue())
        expect(self.mockAPIService.getTrustedDeviceEnrolledAnyInputRequest).to(equal(req))
    }
    
    func testGetReqAuth() {
        mockAPIService.reqAuth(userID: mock.userID, event: mock.event) { _ in }
        
        let evt = CotterEventRequest(
            pubKey: mock.pubKey,
            userID: mock.userID,
            issuer: mock.issuer,
            event: mock.event,
            ipAddr: mock.ipAddr,
            location: mock.location,
            timestamp: mock.timestamp,
            authMethod: mock.method,
            code: nil,
            approved: mock.notApproved
        )
        let req = CreatePendingEventRequest(evt: evt)
        
        expect(self.mockAPIService.reqAuthCalled).to(beTrue())
        expect(self.mockAPIService.reqAuthInputRequest).to(equal(req))
    }
    
    func testGetEvent() {
        mockAPIService.getEvent(eventID: mock.eventID) { _ in }
        
        let req = GetEvent(eventID: mock.eventID)
        
        expect(self.mockAPIService.getEventCalled).to(beTrue())
        expect(self.mockAPIService.getEventInputRequest).to(equal(req))
    }
    
    func testApproveEvent() {
        let cotterEvent = CotterEvent(id: 0, createdAt: "", updatedAt: "", deletedAt: "", clientUserID: mock.userID, issuer: mock.issuer, event: mock.event, ip: mock.ipAddr, location: mock.location, timestamp: mock.timestamp, method: mock.method, new: false, approved: mock.approved)
        
        mockAPIService.approveEvent(event: cotterEvent) { _ in }
        
        let evt = CotterEventRequest(
            pubKey: mock.pubKey,
            userID: mock.userID,
            issuer: mock.issuer,
            event: mock.event,
            ipAddr: mock.ipAddr,
            location: mock.location,
            timestamp: mock.timestamp,
            authMethod: mock.method,
            code: mock.signature,
            approved: mock.approved
        )
        let req = RespondEvent(evtID: mock.eventID, evt: evt)
        
        expect(self.mockAPIService.approveEventCalled).to(beTrue())
        expect(self.mockAPIService.approveEventInputRequest).to(equal(req))
    }
    
    func testRegisterOtherDevice() {
        mockAPIService.registerOtherDevice(qrData: "", userID: mock.userID) { _ in }
        
        let evt = CotterEventRequest(
            pubKey: mock.pubKey,
            userID: mock.userID,
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
        let req = CreateAuthenticationEvent(evt: evt, oauth: true)
        
        expect(self.mockAPIService.registerOtherDeviceCalled).to(beTrue())
        expect(self.mockAPIService.registerOtherDeviceInputRequest).to(equal(req))
    }
    
    func testRemoveTrustedDeviceStatus() {
        mockAPIService.removeTrustedDeviceStatus(userID: mock.userID) { _ in }
        
        let req = RemoveTrustedDeviceStatus(userID: mock.userID, pubKey: mock.pubKey)
        
        expect(self.mockAPIService.removeTrustedDeviceStatusCalled).to(beTrue())
        expect(self.mockAPIService.removeTrustedDeviceStatusInputRequest).to(equal(req))
    }
    
    func testGetNotificationAppID() {
        mockAPIService.getNotificationAppID() { _ in }
        
        let req = GetNotificationAppID()
        
        expect(self.mockAPIService.getNotificationAppIDCalled).to(beTrue())
        expect(self.mockAPIService.getNotificationAppIDInputRequest).to(equal(req))
    }
}
