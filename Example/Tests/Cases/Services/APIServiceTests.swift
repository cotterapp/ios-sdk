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
    let mock = MockAPIServiceVariables()

    func testAuthCalled() {
        var resp: Codable?
        var err: Error? = nil
        
        mockAPIService.auth(
            userID: mock.userID,
            issuer: mock.issuer,
            event: mock.event,
            code: mock.code,
            method: mock.method,
            pubKey: mock.publicKey,
            timestamp: mock.timestamp
        ) { response in
            switch response {
            case .success(let response):
                resp = response
            case .failure(let error):
                err = error
            }
        }

        let evt = CotterEventRequest(
            pubKey: mock.publicKey,
            userID: mock.userID,
            issuer: mock.issuer,
            event: mock.event,
            ipAddr: mock.ip,
            location: mock.location,
            timestamp: mock.timestamp,
            authMethod: mock.method,
            code: mock.code,
            approved: mock.approved
        )
        let req = CreateAuthenticationEvent(evt: evt)
        
        expect(self.mockAPIService.authCalled).to(beTrue())
        expect(self.mockAPIService.authInputRequest).to(equal(req))
        expect(resp).to(beAKindOf(CotterEvent.self))
        expect(err).to(beNil())
    }

    func testRegisterUser() {
        var resp: Codable?
        var err: Error? = nil
        
        mockAPIService.registerUser(userID: mock.userID) { response in
            switch response {
            case .success(let response):
                resp = response
            case .failure(let error):
                err = error
            }
        }

        let req = RegisterUser(userID: mock.userID)
        
        expect(self.mockAPIService.registerUserCalled).to(beTrue())
        expect(self.mockAPIService.registerUserInputRequest).to(equal(req))
        expect(resp).to(beAKindOf(CotterUser.self))
        expect(err).to(beNil())
    }

    func testEnrollUserPin() {
        var resp: Codable?
        var err: Error? = nil
        
        mockAPIService.enrollUserPin(code: mock.code) { response in
            switch response {
            case .success(let response):
                resp = response
            case .failure(let error):
                err = error
            }
        }

        let req = EnrollUserPIN(userID: mock.userID, code: mock.code)
        
        expect(self.mockAPIService.enrollUserPinCalled).to(beTrue())
        expect(self.mockAPIService.enrollUserPinInputRequest).to(equal(req))
        expect(resp).to(beAKindOf(CotterUser.self))
        expect(err).to(beNil())
    }

    func testUpdateUserPin() {
        var resp: Codable?
        var err: Error? = nil
        
        mockAPIService.updateUserPin(oldCode: mock.oldCode, newCode: mock.code) { response in
            switch response {
            case .success(let response):
                resp = response
            case .failure(let error):
                err = error
            }
        }

        let req = UpdateUserPIN(userID: mock.userID, newCode: mock.code, oldCode: mock.oldCode)
        
        expect(self.mockAPIService.updateUserPinCalled).to(beTrue())
        expect(self.mockAPIService.updateUserPinInputRequest).to(equal(req))
        expect(resp).to(beAKindOf(CotterUser.self))
        expect(err).to(beNil())
    }
    
    func testGetBiometricStatus() {
        var resp: Codable?
        var err: Error? = nil
        
        mockAPIService.getBiometricStatus() { response in
            switch response {
            case .success(let response):
                resp = response
            case .failure(let error):
                err = error
            }
        }

        let req = GetBiometricStatus(userID: mock.userID, pubKey: mock.publicKey)
        
        expect(self.mockAPIService.getBiometricStatusCalled).to(beTrue())
        expect(self.mockAPIService.getBiometricStatusInputRequest).to(equal(req))
        expect(resp).to(beAKindOf(EnrolledMethods.self))
        expect(err).to(beNil())
    }

    func testUpdateBiometricStatus() {
        var resp: Codable?
        var err: Error? = nil
        
        mockAPIService.updateBiometricStatus(enrollBiometric: mock.enrolled) { response in
            switch response {
            case .success(let response):
                resp = response
            case .failure(let error):
                err = error
            }
        }

        let req = UpdateBiometricStatus(userID: mock.userID, enroll: mock.enrolled, pubKey: mock.publicKey)
        
        expect(self.mockAPIService.updateBiometricStatusCalled).to(beTrue())
        expect(self.mockAPIService.updateBiometricStatusInputRequest).to(equal(req))
        expect(resp).to(beAKindOf(CotterUser.self))
        expect(err).to(beNil())
    }

    func testRequestToken() {
        var resp: Codable?
        var err: Error? = nil
        
        mockAPIService.requestToken(codeVerifier: mock.codeVerifier, challengeID: mock.challengeID, authorizationCode: mock.authorizationCode, redirectURL: mock.redirectURL) { response in
            switch response {
            case .success(let response):
                resp = response
            case .failure(let error):
                err = error
            }
        }

        let req = RequestToken(codeVerifier: mock.codeVerifier, challengeID: mock.challengeID, authorizationCode: mock.authorizationCode, redirectURL: mock.redirectURL)

        expect(self.mockAPIService.requestTokenCalled).to(beTrue())
        expect(self.mockAPIService.requestTokenInputRequest).to(equal(req))
        expect(resp).to(beAKindOf(CotterIdentity.self))
        expect(err).to(beNil())
    }
    
    func testGetUser() {
        var resp: Codable?
        var err: Error? = nil
        
        mockAPIService.getUser(userID: mock.userID) { response in
            switch response {
            case .success(let response):
                resp = response
            case .failure(let error):
                err = error
            }
        }
        
        let req = GetUser(userID: mock.userID)
        
        expect(self.mockAPIService.getUserCalled).to(beTrue())
        expect(self.mockAPIService.getUserInputRequest).to(equal(req))
        expect(resp).to(beAKindOf(CotterUser.self))
        expect(err).to(beNil())
    }
    
    func testRegisterBiometric() {
        var resp: Codable?
        var err: Error? = nil
        
        mockAPIService.registerBiometric(userID: mock.userID, pubKey: mock.publicKey) { response in
            switch response {
            case .success(let response):
                resp = response
            case .failure(let error):
                err = error
            }
        }
        
        let req = RegisterBiometric(userID: mock.userID, pubKey: mock.publicKey)
        
        expect(self.mockAPIService.registerBiometricCalled).to(beTrue())
        expect(self.mockAPIService.registerBiometricInputRequest).to(equal(req))
        expect(resp).to(beAKindOf(CotterUser.self))
        expect(err).to(beNil())
    }
    
    func testRequestPINReset() {
        var resp: Codable?
        var err: Error? = nil
        
        mockAPIService.requestPINReset(name: mock.name, sendingMethod: mock.sendingMethod, sendingDestination: mock.sendingDestination) { response in
            switch response {
            case .success(let response):
                resp = response
            case .failure(let error):
                err = error
            }
        }
        
        let req = RequestPINReset(userID: mock.userID, name: mock.name, sendingMethod: mock.sendingMethod, sendingDestination: mock.sendingDestination)
        
        expect(self.mockAPIService.requestPINResetCalled).to(beTrue())
        expect(self.mockAPIService.requestPINResetRequest).to(equal(req))
        expect(resp).to(beAKindOf(CotterResponseWithChallenge.self))
        expect(err).to(beNil())
    }
    
    func testVerifyPINResetCode() {
        var resp: Codable?
        var err: Error? = nil
        
        mockAPIService.verifyPINResetCode(resetCode: mock.resetCode, challengeID: mock.challengeID, challenge: mock.challenge) { response in
            switch response {
            case .success(let response):
                resp = response
            case .failure(let error):
                err = error
            }
        }
        
        let req = VerifyPINResetCode(userID: mock.userID, resetCode: mock.resetCode, challengeID: mock.challengeID, challenge: mock.challenge)
        
        expect(self.mockAPIService.verifyPINResetCodeCalled).to(beTrue())
        expect(self.mockAPIService.verifyPINResetCodeInputRequest).to(equal(req))
        expect(resp).to(beAKindOf(CotterBasicResponse.self))
        expect(err).to(beNil())
    }
    
    func testResetPIN() {
        var resp: Codable?
        var err: Error? = nil
        
        mockAPIService.resetPIN(resetCode: mock.resetCode, newCode: mock.code, challengeID: mock.challengeID, challenge: mock.challenge) { response in
            switch response {
            case .success(let response):
                resp = response
            case .failure(let error):
                err = error
            }
        }
        
        let req = ResetPIN(userID: mock.userID, resetCode: mock.resetCode, newCode: mock.code, challengeID: mock.challengeID, challenge: mock.challenge)
        
        expect(self.mockAPIService.resetPINCalled).to(beTrue())
        expect(self.mockAPIService.resetPINInputRequest).to(equal(req))
        expect(resp).to(beAKindOf(CotterBasicResponse.self))
        expect(err).to(beNil())
    }
    
    func testEnrollTrustedDevice() {
        var resp: Codable?
        var err: Error? = nil
        
        mockAPIService.enrollTrustedDevice(clientUserID: mock.userID) { response in
            switch response {
            case .success(let response):
                resp = response
            case .failure(let error):
                err = error
            }
        }
        
        let req = EnrollTrustedDevice(clientUserID: mock.userID, code: mock.publicKey)
        
        expect(self.mockAPIService.enrollTrustedDeviceCalled).to(beTrue())
        expect(self.mockAPIService.enrollTrustedDeviceInputRequest).to(equal(req))
        expect(resp).to(beAKindOf(CotterUser.self))
        expect(err).to(beNil())
    }
    
    func testGetNewEvent() {
        var resp: Codable?
        var err: Error? = nil
        
        mockAPIService.getNewEvent(userID: mock.userID) { response in
            switch response {
            case .success(let response):
                resp = response
            case .failure(let error):
                err = error
            }
        }
        
        let req = GetNewEvent(userID: mock.userID)
        
        expect(self.mockAPIService.getNewEventCalled).to(beTrue())
        expect(self.mockAPIService.getNewEventInputRequest).to(equal(req))
        expect(resp).to(beAKindOf(CotterEvent?.self))
        expect(err).to(beNil())
    }
    
    func testGetTrustedDeviceStatus() {
        var resp: Codable?
        var err: Error? = nil
        
        mockAPIService.getTrustedDeviceStatus(clientUserID: mock.userID) { response in
            switch response {
            case .success(let response):
                resp = response
            case .failure(let error):
                err = error
            }
        }
        
        let req = GetTrustedDeviceStatus(clientUserID: mock.userID, pubKey: mock.publicKey)
        
        expect(self.mockAPIService.getTrustedDeviceStatusCalled).to(beTrue())
        expect(self.mockAPIService.getTrustedDeviceStatusInputRequest).to(equal(req))
        expect(resp).to(beAKindOf(EnrolledMethods.self))
        expect(err).to(beNil())
    }
    
    func testGetTrustedDeviceEnrolledAny() {
        var resp: Codable?
        var err: Error? = nil
        
        mockAPIService.getTrustedDeviceEnrolledAny(userID: mock.userID) { response in
            switch response {
            case .success(let response):
                resp = response
            case .failure(let error):
                err = error
            }
        }
        
        let req = GetTrustedDeviceEnrolledAny(userID: mock.userID)
        
        expect(self.mockAPIService.getTrustedDeviceEnrolledAnyCalled).to(beTrue())
        expect(self.mockAPIService.getTrustedDeviceEnrolledAnyInputRequest).to(equal(req))
        expect(resp).to(beAKindOf(EnrolledMethods.self))
        expect(err).to(beNil())
    }
    
    func testGetReqAuth() {
        var resp: Codable?
        var err: Error? = nil
        
        mockAPIService.reqAuth(clientUserID: mock.userID, event: mock.event) { response in
            switch response {
            case .success(let response):
                resp = response
            case .failure(let error):
                err = error
            }
        }
        
        let evt = CotterEventRequest(
            pubKey: mock.publicKey,
            userID: mock.userID,
            issuer: mock.issuer,
            event: mock.event,
            ipAddr: mock.ip,
            location: mock.location,
            timestamp: mock.timestamp,
            authMethod: mock.method,
            code: nil,
            approved: mock.approved
        )
        let req = CreatePendingEventRequest(evt: evt)
        
        expect(self.mockAPIService.reqAuthCalled).to(beTrue())
        expect(self.mockAPIService.reqAuthInputRequest).to(equal(req))
        expect(resp).to(beAKindOf(CotterEvent.self))
        expect(err).to(beNil())
    }
    
    func testGetEvent() {
        var resp: Codable?
        var err: Error? = nil
        
        mockAPIService.getEvent(eventID: mock.eventID) { response in
            switch response {
            case .success(let response):
                resp = response
            case .failure(let error):
                err = error
            }
        }
        
        let req = GetEvent(eventID: mock.eventID)
        
        expect(self.mockAPIService.getEventCalled).to(beTrue())
        expect(self.mockAPIService.getEventInputRequest).to(equal(req))
        expect(resp).to(beAKindOf(CotterEvent.self))
        expect(err).to(beNil())
    }
    
    func testApproveEvent() {
        var resp: Codable?
        var err: Error? = nil
        
        let cotterEvent = CotterEvent(id: 0, createdAt: "", updatedAt: "", deletedAt: "", clientUserID: mock.userID, issuer: mock.issuer, event: mock.event, ip: mock.ip, location: mock.location, timestamp: mock.timestamp, method: mock.method, new: false, approved: mock.approved)
        
        mockAPIService.approveEvent(event: cotterEvent) { response in
            switch response {
            case .success(let response):
                resp = response
            case .failure(let error):
                err = error
            }
        }
        
        let evt = CotterEventRequest(
            pubKey: mock.publicKey,
            userID: mock.userID,
            issuer: mock.issuer,
            event: mock.event,
            ipAddr: mock.ip,
            location: mock.location,
            timestamp: mock.timestamp,
            authMethod: mock.method,
            code: mock.signature,
            approved: mock.approved
        )
        let req = RespondEvent(evtID: mock.eventID, evt: evt)
        
        expect(self.mockAPIService.approveEventCalled).to(beTrue())
        expect(self.mockAPIService.approveEventInputRequest).to(equal(req))
        expect(resp).to(beAKindOf(CotterEvent.self))
        expect(err).to(beNil())
    }
    
    func testRegisterOtherDevice() {
        var resp: Codable?
        var err: Error? = nil
        
        mockAPIService.registerOtherDevice(qrData: "", userID: mock.userID) { response in
            switch response {
            case .success(let response):
                resp = response
            case .failure(let error):
                err = error
            }
        }
        
        let evt = CotterEventRequest(
            pubKey: mock.publicKey,
            userID: mock.userID,
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
        let req = CreateAuthenticationEvent(evt: evt, oauth: true)
        
        expect(self.mockAPIService.registerOtherDeviceCalled).to(beTrue())
        expect(self.mockAPIService.registerOtherDeviceInputRequest).to(equal(req))
        expect(resp).to(beAKindOf(CotterEvent.self))
        expect(err).to(beNil())
    }
    
    func testRemoveTrustedDeviceStatus() {
        var resp: Codable?
        var err: Error? = nil
        
        mockAPIService.removeTrustedDeviceStatus(userID: mock.userID) { response in
            switch response {
            case .success(let response):
                resp = response
            case .failure(let error):
                err = error
            }
        }
        
        let req = RemoveTrustedDeviceStatus(userID: mock.userID, pubKey: mock.publicKey)
        
        expect(self.mockAPIService.removeTrustedDeviceStatusCalled).to(beTrue())
        expect(self.mockAPIService.removeTrustedDeviceStatusInputRequest).to(equal(req))
        expect(resp).to(beAKindOf(CotterUser.self))
        expect(err).to(beNil())
    }
    
    func testGetNotificationAppID() {
        var resp: Codable?
        var err: Error? = nil
        
        mockAPIService.getNotificationAppID() { response in
            switch response {
            case .success(let response):
                resp = response
            case .failure(let error):
                err = error
            }
        }
        
        let req = GetNotificationAppID()
        
        expect(self.mockAPIService.getNotificationAppIDCalled).to(beTrue())
        expect(self.mockAPIService.getNotificationAppIDInputRequest).to(equal(req))
        expect(resp).to(beAKindOf(CotterNotificationCredential.self))
        expect(err).to(beNil())
    }
}
