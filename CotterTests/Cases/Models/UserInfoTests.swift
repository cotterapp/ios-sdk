//
//  UserInfoTests.swift
//  CotterIOS_Tests
//
//  Created by Raymond Andrie on 4/21/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import XCTest
import Nimble
@testable import Cotter // Need testable annotation to test internal classes

class UserInfoTests: XCTestCase {

    var userInfo: UserInfo!
    
    func setup() {
        let name = "Cotter", method = CotterMethods.Email, destination = "user@gmail.com", resetCode = "11", resetChallengeID = 22, resetChallenge = "x12x"
        userInfo = UserInfo(name: name, sendingMethod: method, sendingDestination: destination)
        userInfo.resetCode = resetCode
        userInfo.resetChallengeID = resetChallengeID
        userInfo.resetChallenge = resetChallenge
    }

    func testClearResetInfo() {
        setup()
        
        userInfo.clearResetInfo()
        
        expect(self.userInfo.name).to(equal("Cotter"))
        expect(self.userInfo.sendingMethod).to(equal(CotterMethods.Email))
        expect(self.userInfo.sendingDestination).to(equal("user@gmail.com"))
        expect(self.userInfo.resetCode).to(beNil())
        expect(self.userInfo.resetChallengeID).to(beNil())
        expect(self.userInfo.resetChallenge).to(beNil())
    }

}
