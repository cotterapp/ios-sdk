//
//  UIViewController.swift
//  Cotter
//
//  Created by Raymond Andrie on 3/5/20.
//

import Foundation

extension UIViewController {
    // This function is called at the start of each Cotter Flow
    func setCotterStatusBarStyle() {
        
        if let window = UIApplication.shared.keyWindow {
            if #available(iOS 13.0, *) {
                Cotter.originalInterfaceStyle = UIScreen.main.traitCollection.userInterfaceStyle
                window.overrideUserInterfaceStyle = .light
            }
        }
    }
    
    // This function is called before leaving Cotter Flow
    func setOriginalStatusBarStyle() {
        if let window = UIApplication.shared.keyWindow {
            if #available(iOS 13.0, *) {
                let style = Cotter.originalInterfaceStyle
                window.overrideUserInterfaceStyle = style ?? UIScreen.main.traitCollection.userInterfaceStyle
            }
        }
    }
}
