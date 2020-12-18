//
//  GetTrustedDeviceStatus.swift
//  Cotter
//
//  Created by Albert Purnama on 3/19/20.
//

import Foundation

public struct GetTrustedDeviceStatus: APIRequest, AutoEquatable {
    public typealias Response = EnrolledMethods
    
    public var path: String {
        if cotterUserID != "" {
            return "/user/methods?cotter_user_id=\(self.cotterUserID)&public_key=\(self.pubKey)&method=TRUSTED_DEVICE"
        }
        return "/user/enrolled/\(self.clientUserID)/TRUSTED_DEVICE/\(self.pubKey)"
    }
    
    public var method: String = "GET"
    
    public var body: Data? {
        return nil
    }
    
    var pubKey:String
    var cotterUserID:String
    var clientUserID:String
    
    // pubKey needs to be a base64 URL safe encoded
    public init(cotterUserID:String, pubKey:String){
        self.cotterUserID = cotterUserID
        self.clientUserID = ""
        self.pubKey = pubKey
    }
    
    public init(clientUserID:String, pubKey:String) {
        self.cotterUserID = ""
        self.clientUserID = clientUserID
        self.pubKey = pubKey
    }
}
