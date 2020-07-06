//
//  EnrollTrustedDevice.swift
//  Cotter
//
//  Created by Albert Purnama on 3/20/20.
//

import Foundation

public struct EnrollTrustedDevice: APIRequest, AutoEquatable {
    public typealias Response = CotterUser
    
    public var path: String {
        // cotter's user ID takes precedence
        if self.cotterUserID != "" {
            return "/user/methods?cotter_user_id=\(self.cotterUserID)"
        }
        return "/user/\(self.clientUserID)"
    }
    
    public let method: String = "PUT"
    
    public var body: Data? {
        let data: [String: Any] = [
            "method": CotterMethods.TrustedDevice,
            "enrolled": true,
            "code": code,
            "algorithm": "EC" // default algo
        ]
        
        let body = try? JSONSerialization.data(withJSONObject: data)
        
        return body
    }
    
    var code:String
    var clientUserID:String
    var cotterUserID:String
    
    public init(clientUserID:String, code:String){
        self.clientUserID = clientUserID
        self.code = code
        self.cotterUserID = ""
    }
    
    public init(cotterUserID:String, code:String) {
        self.clientUserID = ""
        self.code = code
        self.cotterUserID = cotterUserID
    }
}
