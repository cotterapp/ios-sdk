//
//  GetTrustedDeviceStatus.swift
//  Cotter
//
//  Created by Albert Purnama on 3/19/20.
//

import Foundation

public struct GetTrustedDeviceStatus: APIRequest {
    public typealias Response = EnrolledMethods
    
    public var path: String {
        return "/user/enrolled/\(self.userID)/TRUSTED_DEVICE/\(self.pubKey)"
    }
    
    public var method: String = "GET"
    
    public var body: Data? {
        return nil
    }
    
    var pubKey:String
    var userID:String
    
    // pubKey needs to be a base64 URL safe encoded
    public init(userID:String, pubKey:String){
        self.userID = userID
        self.pubKey = pubKey
    }
}
