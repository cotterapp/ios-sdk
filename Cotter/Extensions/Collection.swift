//
//  Collection.swift
//  Cotter
//
//  Created by Raymond Andrie on 3/25/20.
//

import Foundation

// This extension was inspired from
// https://stackoverflow.com/questions/35601059/pretty-test-multiple-variables-against-nil-value-in-swift
extension Collection where Element == Optional<Any> {
    func allNil() -> Bool {
        return allSatisfy { $0 == nil }
    }
    
    func anyNil() -> Bool {
        return first { $0 == nil } != nil
    }
    
    func allNotNil() -> Bool {
        return !allNil()
    }
}
