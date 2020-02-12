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
    let color = UIColor(red: 0.8588, green: 0.8588, blue: 0.8588, alpha: 1.0)
    let width = CGFloat(2.0)
    
    @IBOutlet var view: UIView!
    @IBOutlet weak var topDividerView: UIView!
    
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
        Bundle(for: KeyboardView.self).loadNibNamed("KeyboardView", owner: self, options: nil)
        self.addSubview(view)
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        // Add extra initialization/edits here
        initializeBorders()
        topDividerView.dropShadow()
    }
    
    private func initializeBorders() {
//        oneButton.addTwoThirdsBorder(side: .Right, borderColor: color, borderWidth: width)
//        threeButton.addTwoThirdsBorder(side: .Left, borderColor: color, borderWidth: width)
//        fourButton.addTwoThirdsBorder(side: .Top, borderColor: color, borderWidth: width)
//        fourButton.addFullBorder(side: .Right, borderColor: color, borderWidth: width)
//        fiveButton.addMiddleBorder(side: .Top, borderColor: color, borderWidth: width)
//        sixButton.addTwoThirdsBorder(side: .Top, borderColor: color, borderWidth: width)
//        sixButton.addFullBorder(side: .Left, borderColor: color, borderWidth: width)
//        sevenButton.addTwoThirdsBorder(side: .Top, borderColor: color, borderWidth: width)
//        sevenButton.addFullBorder(side: .Right, borderColor: color, borderWidth: width)
//        eightButton.addTwoThirdsBorder(side: .Top, borderColor: color, borderWidth: width)
//        nineButton.addTwoThirdsBorder(side: .Top, borderColor: color, borderWidth: width)
//        nineButton.addFullBorder(side: .Left, borderColor: color, borderWidth: width)
//        emptyLabel.addGroundNumsTwoThirdsBorder(side: .Top, borderColor: color, borderWidth: width)
//        emptyLabel.addGroundNumsTwoThirdsBorder(side: .Right, borderColor: color, borderWidth: width)
//        zeroButton.addGroundNumsTwoThirdsBorder(side: .Top, borderColor: color, borderWidth: width)
//        backspaceButton.addGroundNumsTwoThirdsBorder(side: .Top, borderColor: color, borderWidth: width)
//        backspaceButton.addGroundNumsTwoThirdsBorder(side: .Left, borderColor: color, borderWidth: width)
        
        oneButton.addFullBorder(side: .Right, borderColor: color, borderWidth: width)
        threeButton.addFullBorder(side: .Left, borderColor: color, borderWidth: width)
        fourButton.addFullBorder(side: .Top, borderColor: color, borderWidth: width)
        fourButton.addFullBorder(side: .Right, borderColor: color, borderWidth: width)
        fiveButton.addFullBorder(side: .Top, borderColor: color, borderWidth: width)
        sixButton.addFullBorder(side: .Top, borderColor: color, borderWidth: width)
        sixButton.addFullBorder(side: .Left, borderColor: color, borderWidth: width)
        sevenButton.addFullBorder(side: .Top, borderColor: color, borderWidth: width)
        sevenButton.addFullBorder(side: .Right, borderColor: color, borderWidth: width)
        eightButton.addFullBorder(side: .Top, borderColor: color, borderWidth: width)
        nineButton.addFullBorder(side: .Top, borderColor: color, borderWidth: width)
        nineButton.addFullBorder(side: .Left, borderColor: color, borderWidth: width)
        emptyLabel.addFullBorder(side: .Top, borderColor: color, borderWidth: width)
        emptyLabel.addFullBorder(side: .Right, borderColor: color, borderWidth: width)
        zeroButton.addFullBorder(side: .Top, borderColor: color, borderWidth: width)
        backspaceButton.addFullBorder(side: .Top, borderColor: color, borderWidth: width)
        backspaceButton.addFullBorder(side: .Left, borderColor: color, borderWidth: width)
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        // Get the tag to find out the number inputted.
        // Will be any number from [1-9], or -1 which is backspace
        let buttonNumber = sender.tag
        self.delegate?.keyboardButtonTapped(buttonNumber: buttonNumber)
    }
}
