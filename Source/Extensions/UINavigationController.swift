//
//  UINavigationController.swift
//  Cotter
//
//  Created by Albert Purnama on 7/5/20.
//

import UIKit

extension UINavigationController {
    func setup() {
        let navbar = self.navigationBar
        navbar.setBackgroundImage(UIImage(), for:.default)
        navbar.shadowImage = UIImage()
        navbar.layoutIfNeeded()
        
        navbar.barTintColor = .white
        navbar.tintColor = Config.instance.colors.primary
    }
}
