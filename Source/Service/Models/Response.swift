//
//  Response.swift
//  Cotter
//
//  Created by Raymond Andrie on 3/24/20.
//

import Foundation

public struct CotterBasicResponse: Codable {
    public var success: Bool
    
    enum CodingKeys: String, CodingKey {
        case success
    }
}

public struct CotterResponseWithChallenge: Codable {
    public var success: Bool
    public var challengeID: Int
    public var challenge: String
    
    enum CodingKeys: String, CodingKey {
        case success
        case challengeID = "challenge_id"
        case challenge
    }
}
