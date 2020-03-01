//
//  API.swift
//  Cotter
//
//  Created by Albert Purnama on 3/1/20.
//

import Foundation

// for GET /enrolled/:userID/:method
public struct EnrolledMethods: Codable {
    public var enrolled:Bool
    public var method:String
}
