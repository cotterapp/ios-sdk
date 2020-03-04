//
//  Callback.swift
//  CotterIOS_Example
//
//  Created by Albert Purnama on 3/4/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import Cotter

class Callback {
    public static let shared = Callback()
    
    private var cb: FinalAuthCallback
    
    public var authCb: FinalAuthCallback {
        get {
            return cb
        }
        
        set {
            cb = newValue
        }
    }
    
    private init() {
        self.cb = { (token:String, err:Error?) in
            if err != nil {
                print(err?.localizedDescription ?? "error in authCb")
                return
            }
            print(token)
            return
        }
    }
}
