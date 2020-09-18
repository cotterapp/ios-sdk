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
    let color = UIColor(red: 0.8588, green: 0.8588, blue: 0.8588, alpha: 0.5)
    let width = CGFloat(2.0)
    
    @IBOutlet var view: UIView!
    @IBOutlet weak var topDividerView: UIView!
    
    @IBOutlet weak var firstStack: UIStackView!
    @IBOutlet weak var secondStack: UIStackView!
    @IBOutlet weak var thirdStack: UIStackView!
    @IBOutlet weak var fourthStack: UIStackView!
    
    @IBOutlet weak var oneButton: UIButton!
    @IBOutlet weak var twoButton: UIButton!
    @IBOutlet weak var threeButton: UIButton!
    @IBOutlet weak var fourButton: UIButton!
    @IBOutlet weak var fiveButton: UIButton!
    @IBOutlet weak var sixButton: UIButton!
    @IBOutlet weak var sevenButton: UIButton!
    @IBOutlet weak var eightButton: UIButton!
    @IBOutlet weak var nineButton: UIButton!
    @IBOutlet weak var zeroButton: UIButton!
    @IBOutlet weak var backspaceButton: UIButton!
    @IBOutlet weak var emptyLabel: UILabel!
    
    var delegate: KeyboardViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    private func initialize() {
        // Load KeyboardView.nib File to View
        Cotter.resourceBundle.loadNibNamed("KeyboardView", owner: self, options: nil)
        view.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(view)
        
        view.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        view.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        view.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        
        let fonts = Config.instance.fonts
        oneButton.titleLabel?.font = fonts.keypad
        twoButton.titleLabel?.font = fonts.keypad
        threeButton.titleLabel?.font = fonts.keypad
        fourButton.titleLabel?.font = fonts.keypad
        fiveButton.titleLabel?.font = fonts.keypad
        sixButton.titleLabel?.font = fonts.keypad
        sevenButton.titleLabel?.font = fonts.keypad
        eightButton.titleLabel?.font = fonts.keypad
        nineButton.titleLabel?.font = fonts.keypad
        zeroButton.titleLabel?.font = fonts.keypad
        
        // Add extra initialization/edits here
        initializeBorders()
        topDividerView.dropShadow()
        versionCheck()
    }
    
    private func versionCheck() {
        if #available(iOS 13, *) {
            // then keyboard will be fine
        } else {
            // keyboard's delete button will be replaced
            self.backspaceButton.setImage(nil, for: .normal)
            self.backspaceButton.setTitle("\u{0000232B}", for: .normal)
        }
    }
    
    private func initializeBorders() {
        // First Numbers Column
        oneButton.addTwoThirdsBorder(side: .Right, borderColor: color, borderWidth: width)
        fourButton.addTwoThirdsBorder(side: .Top, borderColor: color, borderWidth: width)
        fourButton.addFullBorder(side: .Right, borderColor: color, borderWidth: width)
        sevenButton.addTwoThirdsBorder(side: .Top, borderColor: color, borderWidth: width)
        sevenButton.addFullBorder(side: .Right, borderColor: color, borderWidth: width)
        emptyLabel.addGroundNumsTwoThirdsBorder(side: .Top, borderColor: color, borderWidth: width)
        emptyLabel.addGroundNumsTwoThirdsBorder(side: .Right, borderColor: color, borderWidth: width)
        
        // Second Numbers Column
        fiveButton.addTwoThirdsBorder(side: .Top, borderColor: color, borderWidth: width)
        eightButton.addTwoThirdsBorder(side: .Top, borderColor: color, borderWidth: width)
        zeroButton.addGroundNumsTwoThirdsBorder(side: .Top, borderColor: color, borderWidth: width)
        
        // Third Numbers Column
        threeButton.addTwoThirdsBorder(side: .Left, borderColor: color, borderWidth: width)
        sixButton.addTwoThirdsBorder(side: .Top, borderColor: color, borderWidth: width)
        sixButton.addFullBorder(side: .Left, borderColor: color, borderWidth: width)
        nineButton.addTwoThirdsBorder(side: .Top, borderColor: color, borderWidth: width)
        nineButton.addFullBorder(side: .Left, borderColor: color, borderWidth: width)
        backspaceButton.addGroundNumsTwoThirdsBorder(side: .Top, borderColor: color, borderWidth: width)
        backspaceButton.addGroundNumsTwoThirdsBorder(side: .Left, borderColor: color, borderWidth: width)
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        // Get the tag to find out the number inputted.
        // Will be any number from [1-9], or -1 which is backspace
        let buttonNumber = sender.tag
        self.delegate?.keyboardButtonTapped(buttonNumber: buttonNumber)
    }
}
