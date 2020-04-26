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
    
    func setup() {
        imageObject = ImageObject()
    }

    func testSetImage() {
        setup()
        imageObject.setImage(for: testKey, to: testValue)
        
        let result = imageObject.image[testKey]
        
        expect(result).to(match(testValue))
    }

}
