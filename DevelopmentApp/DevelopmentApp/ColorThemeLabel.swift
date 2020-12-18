//
//  ColorThemeLabel.swift
//  CotterIOS_Example
//
//  Created by Albert Purnama on 7/4/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit

class ColorThemeLabel: UILabel {

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
        self.textColor = CotterColor.purple
    }
}
