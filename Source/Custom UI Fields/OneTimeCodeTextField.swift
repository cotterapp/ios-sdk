//
//  OneTimeCodeTextField.swift
//  CotterIOS
//
//  Created by Raymond Andrie on 2/1/20.
//

import Foundation

class OneTimeCodeTextField : UITextField {
    private var isConfigured = false
    private var defaultCharacter = "•"
    private var isPinVisible = false
    private var digitLabels = [UILabel]()
    private lazy var tapRecognizer: UITapGestureRecognizer = {
        let recognizer = UITapGestureRecognizer()
        recognizer.addTarget(self, action: #selector(becomeFirstResponder))
        return recognizer
    }() // Function to recognize when labels are tapped
    
    var didEnterLastDigit: ((String) -> Void)? // Function to run when last PIN digit has been entered
    
    var removeErrorMsg: (() -> Void)? // Function to run when backspace is entered. This is to determine whether to remove error msg
    
    public func configure(with slotCount: Int = 6) {
        guard isConfigured == false else { return }
        isConfigured.toggle()
        
        configureTextField()
        
        let labelsStackView = createLabelsStackView(with: slotCount)
        addSubview(labelsStackView)
        
        addGestureRecognizer(tapRecognizer)
        
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
            label.textColor = UIColor.lightGray
        }
    }
    
    private func configureTextField() {
        tintColor = .clear
        textColor = .clear
        keyboardType = .numberPad
        textContentType = .oneTimeCode
        
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
        stackView.spacing = 8
        
        // Adding each initial password input label
        for _ in 1...count {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textAlignment = .center
            label.font = .systemFont(ofSize: 40)
            label.isUserInteractionEnabled = true
            label.text = defaultCharacter
            label.textColor = UIColor.lightGray
            
            stackView.addArrangedSubview(label)
            
            digitLabels.append(label)
        }
        
        return stackView
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
                currentLabel.textColor = UIColor.black
            } else {
                // User has not inputted text here, so it remains default char
                currentLabel.textColor = UIColor.lightGray
            }
        }
        
        // If full PIN entered, check its validity
        if text.count == digitLabels.count {
            didEnterLastDigit?(text)
        }
    }
}

extension OneTimeCodeTextField : UITextFieldDelegate {
    // This is to ensure that the textfield does not exceed the digitLabels count amount
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let characterCount = textField.text?.count else { return false } // characterCount is one less char than the one in the text field
        let backspaceEntered = string == ""
        
        // If User entered a backspace from the last char, and error message is shown, remove error messages
        print("characterCount: ", characterCount)
        print("digitLabels.count: ", digitLabels.count)
        if characterCount == digitLabels.count && backspaceEntered {
            removeErrorMsg?()
        }
        
        return characterCount < digitLabels.count || backspaceEntered
    }
}
