//
//  BasicButton.swift
//  Cotter
//
//  Created by Albert Purnama on 3/24/20.
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
        
        self.layer.borderColor = UIColor.gray.cgColor
        self.layer.cornerRadius = 4
        self.layer.borderWidth = 1
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
}
