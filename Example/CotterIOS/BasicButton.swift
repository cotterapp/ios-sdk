//
//  BasicButton.swift
//  CotterIOS_Example
//
//  Created by Albert Purnama on 2/29/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit

class BasicButton: UIButton {
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
        backgroundColor = UIColor.init(red: 125, green: 68, blue: 250, alpha: 1)
        
        self.layer.cornerRadius = 10
        
        // MARK: - Title Setup
        setTitleColor(UIColor.white, for: .normal)
    }
}
