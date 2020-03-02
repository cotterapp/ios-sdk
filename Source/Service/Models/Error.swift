//
//  Error.swift
//  Cotter
//
//  Created by Albert Purnama on 3/1/20.
//

import Foundation

public enum CotterAPIError: Error {
    case encoding
    case decoding
    case status(code: Int)
    case server(message: String)
    case network
}
