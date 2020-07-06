//
//  LoadingScreen.swift
//  Cotter
//
//  Created by Albert Purnama on 6/25/20.
//

import Foundation
import UIKit

final class LoadingScreen {
    static let shared = LoadingScreen()
    
    private lazy var backgroundView: UIView = {
        let v = UIView(frame: UIScreen.main.bounds)
        v.backgroundColor = UIColor.black.withAlphaComponent(0.32)
        return v
    }()
    
    private lazy var activityIndicatorContainer: UIView = {
        let v = UIView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        v.center = self.backgroundView.center
        v.layer.cornerRadius = 8
        return v
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView(
            frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        ai.center = CGPoint(x: 40, y: 40)
        ai.hidesWhenStopped = true
        ai.style = .whiteLarge
        ai.color = .white
        return ai
    }()
    
    private init() {}
    
    func start(at window: UIWindow?) {
        if let window = window {
            window.addSubview(self.backgroundView)
            
            self.activityIndicatorContainer.addSubview(self.activityIndicator)
            self.backgroundView.addSubview(self.activityIndicatorContainer)
            
            self.activityIndicator.startAnimating()
        }
    }
    
    func stop() {
        self.activityIndicator.stopAnimating()
        self.backgroundView.removeFromSuperview()
    }
    
}
