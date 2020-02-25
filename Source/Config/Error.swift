//
//  Error.swift
//  Cotter
//
//  Created by Albert Purnama on 2/9/20.
//

import Foundation

enum CotterError: Error {
    case keychainError(String)
    case auth(String)
    case passwordless(String)
}
