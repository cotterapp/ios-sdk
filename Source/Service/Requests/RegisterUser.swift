//
//  RegisterUser.swift
//  Cotter
//
//  Created by Albert Purnama on 3/1/20.
//

import Foundation

public struct RegisterUser: APIRequest {
    public typealias Response = CotterUser
    
    public var path: String {
        return "/user/create"
    }
    
    public let method: String = "POST"
    
    public var body: Data? {
        let data = [
            "client_user_id": self.userID
        ]
        
        let body = try? JSONSerialization.data(withJSONObject: data)
        
        return body
    }
    
    let userID: String
    
    public init(userID:String){
        self.userID = userID
    }
}
