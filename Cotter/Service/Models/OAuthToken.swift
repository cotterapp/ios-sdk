//
//  Token.swift
//  Cotter
//
//  Created by Albert Purnama on 4/29/20.
//

import UIKit

public struct CotterOAuthToken: Codable {
    public var accessToken:String
    public var authMethod:String
    public var expiresIn:Int
    public var idToken:String
    public var refreshToken:String
    public var tokenType:String
    
    enum CodingKeys:String, CodingKey {
        case accessToken = "access_token"
        case authMethod = "auth_method"
        case expiresIn = "expires_in"
        case idToken = "id_token"
        case refreshToken = "refresh_token"
        case tokenType = "token_type"
    }
}
