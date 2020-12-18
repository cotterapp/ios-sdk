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
    
    func setup() {
        langObject = LanguageObject(text: [
            "testKey": "testValue"
        ])
    }
    
    func testInitialText() {
        setup()
        
        let result = langObject.text["testKey"]
        
        expect(result).to(match("testValue"))
    }

    func testSetText() {
        setup()
        langObject.setText(for: "testKey", to: "testValue2")
        
        let result = langObject.text["testKey"]
        
        expect(result).to(match("testValue2"))
    }
    
}
