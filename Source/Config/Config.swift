//
//  Cotter.swift
//  CotterIOS
//
//  Created by Albert Purnama on 2/2/20.
//

import UIKit

// CallbackFunc takes in a string which is the access token and returns a void
public typealias CallbackFunc = (String) -> Void

// Config class will be passed around in the Cotter SDK
class Config: NSObject {
    var parentNav: UINavigationController?
    var callbackView: UIViewController?
    var apiKeyID: String?
    var apiSecretKey: String?
    var userID: String?
    var cotterURL: String?
    var callbackFunc: CallbackFunc?
}
