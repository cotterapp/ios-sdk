//
//  RemoveTrustedDeviceStatus.swift
//  Cotter
//
//  Created by Raymond Andrie on 4/13/20.
//

import Foundation

public struct RemoveTrustedDeviceStatus: APIRequest, AutoEquatable {
    public typealias Response = CotterUser
    
    public var path: String {
        return "/user/\(self.userID)"
    }
    
    public var method: String = "PUT"
    
    public var body: Data? {
        let data: [String: Any] = [
            "method": CotterMethods.TrustedDevice,
            "enrolled": false,
            "code": self.pubKey
        ]
        
        let body = try? JSONSerialization.data(withJSONObject: data)
        
        return body
    }
    
    var userID:String
    var pubKey:String
    
    // pubKey needs to be a base64 URL safe encoded
    public init(userID:String, pubKey:String){
        self.userID = userID
        self.pubKey = pubKey
    }
}
