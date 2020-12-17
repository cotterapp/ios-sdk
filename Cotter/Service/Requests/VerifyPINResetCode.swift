//
//  VerifyPINResetCode.swift
//  Cotter
//
//  Created by Raymond Andrie on 3/24/20.
//

import Foundation

public struct VerifyPINResetCode: APIRequest, AutoEquatable {
    public typealias Response = CotterBasicResponse
    
    public var path: String {
        return "/user/reset/verify/\(self.userID)"
    }
    
    public var method: String = "POST"
    
    public var body: Data? {
        let data: [String:Any] = [
            "method": authMethod,
            "reset_code": resetCode,
            "challenge_id": challengeID,
            "challenge": challenge
        ]
        
        let body = try? JSONSerialization.data(withJSONObject: data)
        
        return body
    }
    
    let userID: String
    let authMethod = CotterMethods.Pin
    let resetCode: String
    let challengeID: Int
    let challenge: String
    
    public init(
        userID: String,
        resetCode: String,
        challengeID: Int,
        challenge: String
    ) {
        self.userID = userID
        self.resetCode = resetCode
        self.challengeID = challengeID
        self.challenge = challenge
    }
}
