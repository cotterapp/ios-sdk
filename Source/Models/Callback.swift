//
//  Callback.swift
//  Cotter
//
//  Created by Albert Purnama on 2/25/20.
//

import Foundation

// FinalCallbackAuth is the general callback function declaration
public typealias FinalAuthCallback = (_ token: String, _ verified: Bool, _ error: Error?) -> Void
