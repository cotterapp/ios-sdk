//
//  Cotter.swift
//  CotterIOS
//
//  Created by Albert Purnama on 2/2/20.
//

import UIKit

// Config class will be passed around in the Cotter SDK
class Config: NSObject {
    var parentNav: UINavigationController?
    var callbackView: UIViewController?
    var apiKeyID: String?
    var apiSecretKey: String?
    var userID: String?
    var cotterURL: String?
}
