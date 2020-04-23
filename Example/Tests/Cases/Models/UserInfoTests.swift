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
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let name = "Cotter", method = CotterMethods.Email, destination = "user@gmail.com", resetCode = "11", resetChallengeID = 22, resetChallenge = "x12x"
        userInfo = UserInfo(name: name, sendingMethod: method, sendingDestination: destination)
        userInfo.resetCode = resetCode
        userInfo.resetChallengeID = resetChallengeID
        userInfo.resetChallenge = resetChallenge
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testClearResetInfo() {
        userInfo.clearResetInfo()
        expect(self.userInfo.name).to(equal("Cotter"))
        expect(self.userInfo.sendingMethod).to(equal(CotterMethods.Email))
        expect(self.userInfo.sendingDestination).to(equal("user@gmail.com"))
        expect(self.userInfo.resetCode).to(beNil())
        expect(self.userInfo.resetChallengeID).to(beNil())
        expect(self.userInfo.resetChallenge).to(beNil())
    }

}
