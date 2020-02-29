//
//  User.swift
//  Cotter
//
//  Created by Albert Purnama on 2/27/20.
//

import Foundation

public struct CotterUser: Codable {
    var id:String
    var createdAt:String
    var updatedAt:String?
    var deletedAt:String?
    var issuer:String
    var clientUserID:String
    public var enrolled:[String]
    var defaultMethod:String?
    
    enum CodingKeys:String, CodingKey {
        case id = "ID"
        case createdAt = "created_at"
        case deletedAt = "deleted_at"
        case updatedAt = "update_at" // notice that this is update_at instead of updated_at!
        case issuer
        case clientUserID = "client_user_id"
        case enrolled
        case defaultMethod = "default_method"
    }
}
