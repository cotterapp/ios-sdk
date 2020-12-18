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
    
    let mockedCotterClient = MockedCotterClient()

    func testSend() {
        let testObject = TestObject(id: 1, path: "testpath", method: "GET")
        
        var resp: Codable?
        var err: Error? = nil
        
        func cb(_ response: CotterResult<CotterBasicResponse>) {
            switch response {
            case .success(let response):
                resp = response
            case .failure(let error):
                err = error
            }
        }
        
        mockedCotterClient.send(testObject) { response in
            cb(response)
        }
        
        expect(self.mockedCotterClient.sendCalled).to(beTrue())
        expect(resp).to(beAKindOf(CotterBasicResponse.self))
        expect(err).to(beNil())
    }
}

struct TestObject : APIRequest {
    typealias Response = CotterBasicResponse
    
    var id: Int
    var path: String
    var method: String
    var body: Data?
}
