//
//  OneTimeCodeTextField.swift
//  CotterIOS
//
//  Created by Raymond Andrie on 2/1/20.
//

import Foundation

class OneTimeCodeTextField : UITextField {
    private var isConfigured = false
    private let defaultColor = Config.instance.colors.pinEmpty
    private let populatedColor = Config.instance.colors.pinFilled
    private let wrongColor = Config.instance.colors.pinError
    private var defaultCharacter = "●"
    private var isPinVisible = false
    private var digitLabels = [UILabel]()
    
    // Function to recognize when labels are tapped
//    private lazy var tapRecognizer: UITapGestureRecognizer = {
//        let recognizer = UITapGestureRecognizer()
//        recognizer.addTarget(self, action: #selector(becomeFirstResponder))
//        return recognizer
//    }()
    
    var didEnterLastDigit: ((String) -> Bool)? // Function to run when last PIN digit has been entered
    
    var removeErrorMsg: (() -> Void)? // Function to run when backspace is entered. This is to determine whether to remove error msg
    
    public func configure(with slotCount: Int = 6) {
        guard isConfigured == false else { return }
        isConfigured.toggle()
        
        configureTextField()
        
        let labelsStackView = createLabelsStackView(with: slotCount)
        addSubview(labelsStackView)
        
//        addGestureRecognizer(tapRecognizer)
        
        NSLayoutConstraint.activate([
            labelsStackView.topAnchor.constraint(equalTo: topAnchor),
            labelsStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            labelsStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            labelsStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    // clear is self explanatory
    public func clear() {
        self.text = ""
        for label in digitLabels {
            label.text = defaultCharacter
            label.textColor = defaultColor
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
        delegate = self
    }
    
    // Create the initial Password Labels
    private func createLabelsStackView(with count: Int) -> UIStackView {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = -24
        
        // Adding each initial password input label
        for _ in 1...count {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textAlignment = .center
            label.font = Config.instance.fonts.pin
            label.isUserInteractionEnabled = true
            label.text = defaultCharacter
            label.textColor = defaultColor
            
            stackView.addArrangedSubview(label)
            
            digitLabels.append(label)
        }
        
        return stackView
    }
    
    public func appendNumber(buttonNumber: NSInteger) {
        // Ensure only 6 digit input
        guard let text = self.text, text.count <= digitLabels.count - 1 else { return }
        
        // Append new char and refresh Digit Labels
        let num = NSString(format: "%d", buttonNumber)
        self.text?.append(num as String)
        codeDidChange()
    }
    
    public func removeNumber() {
        guard let text = self.text else { return }
        
        // If text field is 6 digits already, and we are on the same view, an error msg is displayed. Entering a backspace would remove this error msg
        if text.count == digitLabels.count {
            removeErrorMsg?()
        }
        
        // If text field is not empty, remove last char and refresh digit labels
        if !text.isEmpty {
            self.text?.removeLast()
        }
        codeDidChange()
    }
    
    // Toggle PIN Visibility between dots or numbers
    public func togglePinVisibility() {
        isPinVisible.toggle()
        codeDidChange()
    }
    
    // On Code Change (I/O) Function
    @objc
    private func codeDidChange() {
        // Ensure only 6 digit input
        guard let text = self.text, text.count <= digitLabels.count else { return }
        
        // For each label, show the dot/number on the text field
        for i in 0 ..< digitLabels.count {
            let currentLabel = digitLabels[i]
            currentLabel.text = defaultCharacter
            
            if i < text.count {
                // User has inputted text here, so show in text field label
                let index = text.index(text.startIndex, offsetBy: i)
                if isPinVisible {
                    // Show the numbers
                    currentLabel.text = String(text[index])
                }
                currentLabel.textColor = populatedColor
            } else {
                // User has not inputted text here, so it remains default char
                currentLabel.textColor = defaultColor
            }
        }
        
        // If full PIN entered, check its validity
        if text.count == digitLabels.count {
            guard let correctPIN = didEnterLastDigit?(text) else { return }
            if !correctPIN {
                for i in 0 ..< digitLabels.count {
                    let currentLabel = digitLabels[i]
                    if i < text.count {
                        currentLabel.textColor = wrongColor
                    }
                }
            }
        }
    }
}

extension OneTimeCodeTextField : UITextFieldDelegate {
    // This is to ensure that the text field does not exceed the digitLabels count amount
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let characterCount = textField.text?.count else { return false } // characterCount is one less char than the one in the text field
        let backspaceEntered = string == ""

        // If User entered a backspace from the last char, and error message is shown, remove error messages
        if characterCount == digitLabels.count && backspaceEntered {
            removeErrorMsg?()
        }

        return characterCount < digitLabels.count || backspaceEntered
    }
}
