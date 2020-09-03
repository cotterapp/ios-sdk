//
//  Callback.swift
//  Cotter
//
//  Created by Albert Purnama on 2/25/20.
//

import Foundation
import os.log

// FinalCallbackAuth is the general callback function declaration
public typealias FinalAuthCallback = (_ token: String, _ error: Error?) -> Void

// CotterAuthCallback is the callback that returns the OAuth Token
public typealias CotterAuthCallback = (_ token: CotterOAuthToken?, _ error: Error?) -> Void

public func DoNothingCallback(_ token: CotterOAuthToken?, _ err:Error?) -> Void {
    os_log("%{public}@ { token: %{public}@ err: %{public}@ }",
           log: Config.instance.log, type: .error,
           #function, token?.accessToken ?? "", err?.localizedDescription ?? "")
}
