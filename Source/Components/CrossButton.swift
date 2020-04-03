//
//  CrossButton.swift
//  Cotter
//
//  Created by Albert Purnama on 3/25/20.
//

import UIKit

class CrossButton: UIButton {
    
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
        self.setTitle("\u{2717}", for: .normal)
        self.setTitleColor(UIColor.black, for: .normal)
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
