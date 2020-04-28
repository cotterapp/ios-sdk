//
//  CotterImagesTests.swift
//  CotterIOS_Tests
//
//  Created by Raymond Andrie on 4/21/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import XCTest
import Nimble
@testable import Cotter

class CotterImagesTests: XCTestCase {
    
    let testKey = VCImageKey.logo
    let testValue = "test-image-path"
    var cotterImages = CotterImages.instance

    func setup() {
        Config.instance.images.image[testKey] = testValue
    }

    func testGetImage() {
        setup()
        
        let result = cotterImages.getImage(for: testKey)
        
        expect(result).to(match(testValue))
    }
    
    func testGetNoImage() {
        let result = cotterImages.getImage(for: "fake-key")
        
        expect(result).to(match("Image not found."))
    }

}
