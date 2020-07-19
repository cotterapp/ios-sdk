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
        if self.userID != "" {
            return "/user/\(self.userID)"
        } else {
            return "/user?identifier=\(self.identifier)"
        }
    }
    
    public var method: String = "GET"
    
    public var body: Data? {
        return nil
    }
    
    let userID: String
    let identifier: String
    
    public init(userID:String){
        self.userID = userID
        self.identifier = ""
    }
    
    public init(identifier:String) {
        self.userID = ""
        self.identifier = identifier
    }
}
