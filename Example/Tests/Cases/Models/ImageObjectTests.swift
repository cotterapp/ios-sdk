//
//  ImageObject.swift
//  CotterIOS_Tests
//
//  Created by Raymond Andrie on 4/22/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import XCTest
import Nimble
@testable import Cotter

class ImageObjectTests: XCTestCase {

    let testKey = VCImageKey.pinSuccessImg
    let testValue = "success"
    var imageObject: ImageObject!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        imageObject = ImageObject()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSetImage() {
        imageObject.setImage(for: testKey, to: testValue)
        let result = imageObject.image[testKey]
        expect(result).to(match(testValue))
    }

}
