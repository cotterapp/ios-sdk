//
//  RefreshToken.swift
//  Cotter
//
//  Created by Albert Purnama on 7/10/20.
//

import Foundation

public struct RefreshToken: APIRequest, AutoEquatable {
    public typealias Response = CotterOAuthToken
    
    public var path: String {
        return "/token"
    }
    
    public var method: String = "POST"
    
    public var body: Data? {
        let data: [String:Any] = [
            "grant_type": "refresh_token",
            "refresh_token": refreshToken
        ]
        
        let body = try? JSONSerialization.data(withJSONObject: data)
        
        return body
    }
    
    let refreshToken: String
    
    public init(
        refreshToken: String
    ) {
        self.refreshToken = refreshToken
    }
}
