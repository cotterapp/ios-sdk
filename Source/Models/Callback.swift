//
//  Callback.swift
//  Cotter
//
//  Created by Albert Purnama on 2/25/20.
//

import Foundation

// FinalCallbackAuth is the general callback function declaration
public typealias FinalAuthCallback = (_ token: String, _ error: Error?) -> Void

// CotterAuthCallback is the callback that returns the OAuth Token
public typealias CotterAuthCallback = (_ token: CotterOAuthToken?, _ error: Error?) -> Void

public func DoNothingCallback(_ token: CotterOAuthToken?, _ err:Error?) -> Void {
    print("DoNothingCallback token:", token)
    print("DoNothingCallback error:", err)
}
