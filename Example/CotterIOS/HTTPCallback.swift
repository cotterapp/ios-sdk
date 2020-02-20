//
//  HTTPCallback.swift
//  CotterIOS_Example
//
//  Created by Albert Purnama on 2/17/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import Cotter

// DefaultCallback should be the client's default error callback implementations
class DefaultCallback: HTTPCallback {
    // networkErrorHandler is the default handler for network errors
    public func networkErrorHandler(err: Error?) {
        print("error", err ?? "Unknown error")
        
        return
    }
    
    // statusNotOKHandler is the default handler for non 2XX responses
    public func statusNotOKHandler(statusCode: Int) {
        print("status \(statusCode) for the request")
        
        return
    }
    
    // successfulHandler is the default handler for successful requests
    public func successfulHandler(response: Data?) {
        guard let response = response else {
            print("failed parsing data to string")
            return
        }
        let respString = String(decoding:response, as: UTF8.self)
        print("successfully created the request with response: \(respString)")
        
        return
    }
}