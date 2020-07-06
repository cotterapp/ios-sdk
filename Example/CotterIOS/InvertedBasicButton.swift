//
//  InvertedBasicButton.swift
//  CotterIOS_Example
//
//  Created by Albert Purnama on 7/4/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit

class InvertedBasicButton: UIButton {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func setup() {
        // MARK: - Appearance Setup
        heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        // transparent background
        backgroundColor = UIColor.clear
        
        // button border
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 1
        self.layer.borderColor = CotterColor.purple.cgColor
        
        // MARK: - Title Setup
        setTitleColor(UIColor.init(red: 125, green: 68, blue: 250, alpha: 1), for: .normal)
    }
}
