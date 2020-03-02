//
//  UpdateUserPIN.swift
//  Cotter
//
//  Created by Albert Purnama on 3/1/20.
//

import Foundation

public struct UpdateUserPIN: APIRequest {
    public typealias Response = CotterUser
    
    public var path: String {
        return "/user/\(self.userID)"
    }
    
    public let method: String = "PUT"
    
    public var body: Data? {
        let data: [String: Any] = [
            "method": "PIN",
            "enrolled": true,
            "current_code": self.oldCode,
            "code": self.newCode,
            "change_code": true
        ]
        
        let body = try? JSONSerialization.data(withJSONObject: data)
        
        return body
    }
    
    var oldCode:String
    var newCode:String
    var userID:String
    
    public init(userID:String, newCode:String, oldCode:String){
        self.userID = userID
        self.newCode = newCode
        self.oldCode = oldCode
    }
}
