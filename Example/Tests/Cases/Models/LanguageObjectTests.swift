//
//  LanguageObjectTests.swift
//  CotterIOS_Tests
//
//  Created by Raymond Andrie on 4/22/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import XCTest
import Nimble
@testable import Cotter

class LanguageObjectTests: XCTestCase {

    var langObject: LanguageObject!
    
    override func setUpWithError() throws {
        langObject = LanguageObject(text: [
            "testKey": "testValue"
        ])
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testInitialText() {
        let result = langObject.text["testKey"]
        expect(result).to(match("testValue"))
    }

    func testSetText() {
        langObject.setText(for: "testKey", to: "testValue2")
        let result = langObject.text["testKey"]
        expect(result).to(match("testValue2"))
    }
    
}
