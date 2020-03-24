//
//  UserInfo.swift
//  Cotter
//
//  Created by Raymond Andrie on 3/24/20.
//

import Foundation

class UserInfo {
    let name: String
    let sendingMethod: String
    let sendingDestination: String
    
    public init(
        name: String,
        sendingMethod: String,
        sendingDestination: String
    ) {
        self.name = name
        self.sendingMethod = sendingMethod
        self.sendingDestination = sendingDestination
    }
}
