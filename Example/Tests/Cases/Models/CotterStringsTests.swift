//
//  CotterStringsTests.swift
//  CotterIOS_Tests
//
//  Created by Raymond Andrie on 4/22/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import XCTest
import Nimble
@testable import Cotter

class CotterStringsTests: XCTestCase {

    let testKey = PINViewControllerKey.navTitle
    let testValue = "Test Title"
    var cotterStrings = CotterStrings.instance
    
    func setup() {
        Config.instance.strings.text[testKey] = testValue
    }

    func testGetText() throws {
        setup()
        
        let result = cotterStrings.getText(for: testKey)
        
        expect(result).to(match(testValue))
    }
    
    func testGetNoImage() {
        let result = cotterStrings.getText(for: "fake-key")
        
        expect(result).to(match("Text not found."))
    }
}
