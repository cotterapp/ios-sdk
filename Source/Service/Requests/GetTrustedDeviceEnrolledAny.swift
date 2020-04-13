//
//  GetTrustedDeviceEnrolledAny.swift
//  Cotter
//
//  Created by Raymond Andrie on 4/13/20.
//

import Foundation

public struct GetTrustedDeviceEnrolledAny: APIRequest {
    public typealias Response = EnrolledMethods
    
    public var path: String {
        return "/user/enrolled/any/\(self.userID)/TRUSTED_DEVICE"
    }
    
    public var method: String = "GET"
    
    public var body: Data? {
        return nil
    }
    
    var userID: String
    
   public init(userID:String){
       self.userID = userID
   }
}
