//
//  GetUser.swift
//  Cotter
//
//  Created by Albert Purnama on 3/1/20.
//

import Foundation

public struct GetUser: APIRequest, AutoEquatable {
    public typealias Response = CotterUser
    
    public var path: String {
        return "/user/\(self.userID)"
    }
    
    public var method: String = "GET"
    
    public var body: Data? {
        return nil
    }
    
    let userID: String
    
    public init(userID:String){
        self.userID = userID
    }
}
