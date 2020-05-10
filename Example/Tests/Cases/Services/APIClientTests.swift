//
//  APIClientTests.swift
//  CotterIOS_Tests
//
//  Created by Raymond Andrie on 5/10/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import XCTest
import Nimble
@testable import Cotter

class APIClientTests: XCTestCase {
    
    let mockedAPIClient = MockedAPIClient()

    func testSend() {
        let testObject = TestObject(id: 1, path: "testpath", method: "GET")
        
        mockedAPIClient.send(testObject) { _ in
            
        }
        
        expect(self.mockedAPIClient.sendCalled).to(beTrue())
    }
}

struct TestObject : APIRequest {
    typealias Response = CotterBasicResponse
    
    var id: Int
    var path: String
    var method: String
    var body: Data?
}
