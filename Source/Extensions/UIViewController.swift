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

extension UIViewController {
    func getTitleLeft(with text: String) -> UIBarButtonItem {
        let label = UILabel()
        label.text = text
        
        label.font = Config.instance.fonts.heading
        label.textColor = .black
        label.numberOfLines = 1
        label.textAlignment = .left
        // fix ios 10 not show left bar button item
        label.sizeToFit()
        let titleLeft = UIBarButtonItem(customView: label)
        return titleLeft
    }
    
    func setupLeftTitleBar(with text: String) {
        let leftItem = self.getTitleLeft(with: text)
        if self.navigationItem.leftBarButtonItems != nil { self.navigationItem.leftBarButtonItems?.append(leftItem) }
        else { self.navigationItem.leftBarButtonItem = leftItem }
        
        self.navigationItem.leftItemsSupplementBackButton = true
        
        self.setupDefaultNavbar()
    }
    
    func setupDefaultNavbar() {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
}

// MARK: - Get class name 
/*
 Get class name by instance or type level
 Foo().typeName         // print "Foo"
 Foo.typeName           // print "Foo"
 */

protocol NameDescribable {
    var typeName: String { get }
    static var typeName: String { get }
}

extension NameDescribable {
    
    var typeName: String {
        return String(describing: type(of: self))
    }
    
    static var typeName: String {
        return String(describing: self)
    }
}

extension UIViewController: NameDescribable {}
