//
//  Environment.swift
//  CotterIOS_Example
//
//  Created by Raymond Andrie on 4/3/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation

class Environment {
    static let shared = Environment()
    let env = ProcessInfo.processInfo.environment
    
    var COTTER_API_KEY_ID: String? {
        return env["COTTER_API_KEY_ID"]
    }
    
    var COTTER_API_SECRET_KEY: String? {
        return env["COTTER_API_SECRET_KEY"]
    }
    
    var DEV_MODE: String? {
        return env["DEV_MODE"]
    }
}
