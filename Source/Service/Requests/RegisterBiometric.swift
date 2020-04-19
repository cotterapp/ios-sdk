//
//  RegisterBiometric.swift
//  Cotter
//
//  Created by Albert Purnama on 3/1/20.
//

import Foundation

public struct RegisterBiometric: APIRequest {
    public typealias Response = CotterUser

    public var path: String {
        return  "/user/\(self.userID)"
    }

    public var method: String = "PUT"

    public var body: Data? {
        let data: [String:Any] = [
            "method": CotterMethods.Biometric,
            "enrolled": true,
            "code": pubKey
        ]
        
        let body = try? JSONSerialization.data(withJSONObject: data)
        
        return body
    }
    
    var pubKey:String
    var userID:String
    
    // pubKey needs to be a base64 URL safe encoded
    public init(userID:String, pubKey:String){
        self.userID = userID
        self.pubKey = pubKey
    }
}
