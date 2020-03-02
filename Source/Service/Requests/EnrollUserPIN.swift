//
//  EnrollUserPIN.swift
//  Cotter
//
//  Created by Albert Purnama on 3/1/20.
//

import Foundation

public struct EnrollUserPIN: APIRequest {
    public typealias Response = CotterUser
    
    public var path: String {
        return "/user/\(self.userID)"
    }
    
    public let method: String = "PUT"
    
    public var body: Data? {
        let data: [String: Any] = [
            "method": "PIN",
            "enrolled": true,
            "code": code
        ]
        
        let body = try? JSONSerialization.data(withJSONObject: data)
        
        return body
    }
    
    var code:String
    var userID:String
    
    public init(userID:String, code:String){
        self.userID = userID
        self.code = code
    }
}
