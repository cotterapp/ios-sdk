//
//  RequestPINReset.swift
//  Cotter
//
//  Created by Raymond Andrie on 3/24/20.
//

import Foundation

public struct RequestPINReset: APIRequest {
    public typealias Response = CotterResponseWithChallenge
    
    public var path: String {
        return "/user/reset/start/\(self.userID)"
    }
    
    public var method: String = "POST"
    
    public var body: Data? {
        let data: [String:Any] = [
            "method": authMethod,
            "name": name,
            "sending_method": sendingMethod,
            "sending_destination": sendingDestination
        ]
        
        let body = try? JSONSerialization.data(withJSONObject: data)
        
        return body
    }
    
    let userID: String
    let authMethod = CotterConstants.MethodPIN
    let name: String
    let sendingMethod: String
    let sendingDestination: String
    
    
    public init(
        userID: String,
        name: String,
        sendingMethod: String,
        sendingDestination: String
    ) {
        self.userID = userID
        self.name = name
        self.sendingMethod = sendingMethod
        self.sendingDestination = sendingDestination
    }
}
