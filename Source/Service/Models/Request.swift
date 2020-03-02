//
//  Request.swift
//  Cotter
//
//  Created by Albert Purnama on 3/1/20.
//

import Foundation

public protocol APIRequest: Encodable {
    associatedtype Response: Decodable
    
    var path: String { get }
    var method: String { get }
    var body: Data? { get }
}
