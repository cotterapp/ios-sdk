//
//  EventCreateResponse.swift
//  Cotter
//
//  Created by Albert Purnama on 2/17/20.
//

import Foundation

struct CreateEventResponse: Codable {
    var id:Int
    var createdAt:String
    var updatedAt:String?
    var deletedAt:String?
    var clientUserID:String
    var issuer:String
    var event:String
    var ip:String
    var location:String
    var timestamp:String
    var method:String
    var new:Bool
    var approved:Bool
    
    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case createdAt = "CreatedAt"
        case deletedAt = "DeletedAt"
        case clientUserID = "client_user_id"
        case issuer
        case event
        case ip
        case location
        case timestamp
        case method
        case new
        case approved
    }
}
