//
//  ResetCodeTextField.swift
//  Cotter
//
//  Created by Raymond Andrie on 3/19/20.
//

import UIKit

protocol ResetCodeTextFieldDelegate {
    // Function to run when last PIN digit has been entered
    func didEnterLastDigit(_: String) -> Void
    
    // Function to run when backspace is entered.
    // This is to determine whether to remove error msg
    func removeErrorMsg() -> Void
}

enum ResetCodeState {
    case initial
    case populated
    case invalid
}

class ResetCodeTextField: UITextField {
    private var isConfigured = false
    
    private let defaultBgColor = UIColor(red: 0.8667, green: 0.8667, blue: 0.8667, alpha: 1.0) /* #dddddd */
    private let populatedBgColor = UIColor(red: 0.6863, green: 0.9294, blue: 0.6118, alpha: 1.0) /* #afed9c */
    private let invalidBgColor = UIColor(red: 1, green: 0.6, blue: 0.6, alpha: 1.0) /* #ff9999 */
    
    private let invalidTextColor = UIColor(red: 0.7176, green: 0, blue: 0.0353, alpha: 1.0)
    private let populatedTextColor = UIColor(red: 0.2078, green: 0, blue: 0.7882, alpha: 1.0)
    
    private let defaultCharacter = ""
    private var digitLabels = [UILabel]()
    
    var resetDelegate: ResetCodeTextFieldDelegate?
    
    public func setBackgroundColor(state: ResetCodeState) {
        var labelTextColor: UIColor
        var labelBackgroundColor: UIColor
        
        switch(state){
        case .populated:
            labelTextColor = populatedTextColor
            labelBackgroundColor = populatedBgColor
        case .invalid:
            labelTextColor = invalidTextColor
            labelBackgroundColor = invalidBgColor
        default:
            labelTextColor = defaultBgColor
            labelBackgroundColor = defaultBgColor
        }
        
        for i in 0 ..< digitLabels.count {
            let currentLabel = digitLabels[i]
            currentLabel.textColor = labelTextColor
            currentLabel.backgroundColor = labelBackgroundColor
        }
    }
    
    public func configure(with slotCount:Int = 4) {
        guard isConfigured == false else { return }
        isConfigured.toggle()
        
        configureTextField()
        
        let labelsStackView = createLabelsStackView(with: slotCount)
        addSubview(labelsStackView)
        
        NSLayoutConstraint.activate([
            labelsStackView.topAnchor.constraint(equalTo: topAnchor),
            labelsStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            labelsStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            labelsStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    public func clear() {
        self.text = ""
        for label in digitLabels {
            label.text = defaultCharacter
            label.backgroundColor = defaultBgColor
        }
    }
    
    private func configureTextField() {
        tintColor = .clear
        textColor = .clear
        if #available(iOS 12.0, *) {
            textContentType = .oneTimeCode
        } else {
            // Fallback on earlier versions
            // in this case textContentType doesn't need to be set.
        }
        
        addTarget(self, action: #selector(codeDidChange), for: .editingChanged)
    }
    
    // Create the initial Password Labels
    private func createLabelsStackView(with count: Int) -> UIStackView {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        
        // Adding each initial password input label
        for _ in 1...count {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textAlignment = .center
            label.font = Config.instance.fonts.resetPin
            label.isUserInteractionEnabled = true
            label.backgroundColor = defaultBgColor
            label.text = defaultCharacter
            
            // Set rounded corners
            label.layer.cornerRadius = 10.0
            label.layer.masksToBounds = true
            
            stackView.addArrangedSubview(label)
            
            digitLabels.append(label)
        }
        
        return stackView
    }
    
    public func appendNumber(buttonNumber: NSInteger) {
        // Ensure only 4 digit input
        guard let text = self.text, text.count <= digitLabels.count - 1 else { return }
        
        // Append new char and refresh Digit Labels
        let num = NSString(format: "%d", buttonNumber)
        self.text?.append(num as String)
        codeDidChange()
    }
    
    public func removeNumber() {
        guard let text = self.text else { return }
        
        // If text field is 4 digits already, an error msg is displayed. Entering a backspace would remove this error msg
        if text.count == digitLabels.count {
            resetDelegate?.removeErrorMsg()
        }
        
        // If text field is not empty, remove last char and refresh digit labels
        if !text.isEmpty {
            self.text?.removeLast()
        }
        codeDidChange()
    }
    
    // On Code Change (I/O) Function
    @objc
    private func codeDidChange() {
        // Ensure only 4 digit input
        guard let text = self.text, text.count <= digitLabels.count else { return }
        
        // For each label, show the dot/number on the text field
        for i in 0 ..< digitLabels.count {
            let currentLabel = digitLabels[i]
            currentLabel.text = defaultCharacter
            currentLabel.backgroundColor = defaultBgColor
            
            if i < text.count {
                // User has inputted text here, so show in text field label
                let index = text.index(text.startIndex, offsetBy: i)
                currentLabel.text = String(text[index])
                currentLabel.textColor = populatedTextColor
                currentLabel.backgroundColor = populatedBgColor
            }
        }
        
        // If full PIN entered, check its validity
        if text.count == digitLabels.count {
            resetDelegate?.didEnterLastDigit(text)
        }
    }
}
