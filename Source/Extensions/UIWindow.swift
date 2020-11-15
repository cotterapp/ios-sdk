//
//  UIWindow.swift
//  Cotter
//
//  Created by Albert Purnama on 11/14/20.
//

import UIKit

extension UIWindow {
    static var key: UIWindow? {
        if #available(iOS 13, *) {
            return UIApplication.shared.windows.first { $0.isKeyWindow }
        } else {
            return UIApplication.shared.keyWindow
        }
    }
}
