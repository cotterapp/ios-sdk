//
//  KeyboardView.swift
//  CotterIOS
//
//  Created by Raymond Andrie on 2/3/20.
//

import UIKit

protocol KeyboardViewDelegate: class {
    func keyboardButtonTapped(buttonNumber: NSInteger)
}

class KeyboardView: UIView {
    @IBOutlet var view: UIView!
    
    var delegate: KeyboardViewDelegate?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // Load KeyboardView.nib File
        Bundle(for: KeyboardView.self).loadNibNamed("KeyboardView", owner: self, options: nil)
        self.addSubview(view)
    }
    
    @IBAction func buttonTapped(sender: UIButton) {
        // Get the tag to find out the number inputted.
        // Will be any number from [1-9], or -1 which is backspace
        let buttonNumber = sender.tag
        self.delegate?.keyboardButtonTapped(buttonNumber: buttonNumber)
    }
}
