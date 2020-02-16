//
//  PINViewController.swift
//  CotterIOS
//
//  Created by Albert Purnama on 2/2/20.
//

import Foundation
import UIKit

class PINViewController : UIViewController {
    // MARK: - Keys for Strings
    static let showPin = "PINViewController/showPin"
    static let hidePin = "PINViewController/hidePin"
    static let closeTitle = "PINViewController/closeTitle"
    static let closeMessage = "PINViewController/closeMessage"
    static let stayOnView = "PINViewController/stayOnView"
    static let leaveView = "PINViewController/leaveView"
    
    // Alert Service
    let closeTitleText = CotterStrings.instance.getText(for: closeTitle)
    let closeMessageText = CotterStrings.instance.getText(for: closeMessage)
    let stayText = CotterStrings.instance.getText(for: stayOnView)
    let leaveText = CotterStrings.instance.getText(for: leaveView)
    lazy var alertService: AlertService = {
        let alert = AlertService(vc: self, title: closeTitleText, body: closeMessageText, actionButtonTitle: leaveText, cancelButtonTitle: stayText)
        alert.delegate = self
        return alert
    }()
    
    // Code Text Field
    @IBOutlet weak var codeTextField: OneTimeCodeTextField!
    
    // PIN Visibility Toggle Button
    @IBOutlet weak var pinVisibilityButton: UIButton!
    let showPinText = CotterStrings.instance.getText(for: showPin)
    let hidePinText = CotterStrings.instance.getText(for: hidePin)
    
    // Error Label
    @IBOutlet weak var errorLabel: UILabel!
    
    // Keyboard
    @IBOutlet weak var keyboardView: KeyboardView!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("loaded PIN Cotter Enrollment View")
        
        // Set-up
        addConfigs()
        addDelegates()
        instantiateCodeTextFieldFunctions()
    }
    
    func instantiateCodeTextFieldFunctions() {
        // Instantiate Function to run when user enters wrong PIN code
        codeTextField.removeErrorMsg = {
            // Remove error msg if it is present
            if !self.errorLabel.isHidden {
                self.toggleErrorMsg(msg: nil)
            }
        }
        
        // Instantiate Function to run when PIN is fully entered
        codeTextField.didEnterLastDigit = { code in
            print("PIN Code Entered: ", code)
            
            // If code has repeating digits or is a straight number, show error.
            let pattern = "\\b(\\d)\\1+\\b"
            let result = code.range(of: pattern, options: .regularExpression)
            
            // Ensure consecutive PIN number is rejected
            if result != nil || self.findSequence(sequenceLength: code.count, in: code) {
                if self.errorLabel.isHidden {
                    self.toggleErrorMsg(msg: PinErrorMessages.badPIN)
                }
                return false
            }

            // Clear Code text Field before continuing
            self.codeTextField.clear()
            
            // Go to PIN Confirmation page
            let confirmVC = self.storyboard?.instantiateViewController(withIdentifier: "PINConfirmViewController")as! PINConfirmViewController
            confirmVC.prevCode = code
            self.navigationController?.pushViewController(confirmVC, animated: true)
            return true
        }
    }
    
    func addConfigs() {
        // Implement Custom Back Button instead of default in Nav controller
        self.navigationItem.hidesBackButton = true
        let crossButton = UIBarButtonItem(title: "\u{2717}", style: UIBarButtonItem.Style.plain, target: self, action: #selector(promptClose(sender:)))
        crossButton.tintColor = UIColor.black
        self.navigationItem.leftBarButtonItem = crossButton
        
        // Remove default Nav controller styling
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layoutIfNeeded()
        
        codeTextField.configure()
        configureErrorMsg()
    }
    
    func addDelegates() {
        self.keyboardView.delegate = self
    }
    
    private func configurePinVisButton() {
        pinVisibilityButton.setTitle("", for: .normal)
    }
    
    private func configureErrorMsg() {
        errorLabel.isHidden = true
    }
    
    func toggleErrorMsg(msg: String?) {
        errorLabel.isHidden.toggle()
        if !errorLabel.isHidden {
            errorLabel.text = msg
        }
    }
    
    @IBAction func onClickPinVis(_ sender: UIButton) {
        codeTextField.togglePinVisibility()
        if sender.title(for: .normal) == PinDisplayText.showPinText {
            sender.setTitle(PinDisplayText.hidePinText, for: .normal)
        } else {
            sender.setTitle(PinDisplayText.showPinText, for: .normal)
        }
    }
    
    @objc private func promptClose(sender: UIBarButtonItem) {
        alertService.show(from: self)
    }
    
    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: - Private Helper Functions
extension PINViewController {
    private func findSequence(sequenceLength: Int, in string: String) -> Bool {
        // It would be better to extract this out of func
        let digits = CharacterSet.decimalDigits
        let controlSet = digits
        // ---

        let scalars = string.unicodeScalars
        let unicodeArray = scalars.map({ $0 })

        var i = 0

        var increasingLength = 1
        var decreasingLength = 1
        for number in unicodeArray where controlSet.contains(number) {
            if i+1 >= unicodeArray.count {
                break
            }
            let nextNumber = unicodeArray[i+1]
            
            if UnicodeScalar(number.value-1) == nextNumber {
                decreasingLength += 1
            }

            if UnicodeScalar(number.value+1) == nextNumber {
                increasingLength += 1
            }
            
            if decreasingLength >= sequenceLength || increasingLength >= sequenceLength {
                return true
            }
            i += 1
        }
        return false
    }
}

// MARK: - KeyboardViewDelegate
extension PINViewController : KeyboardViewDelegate {
    func keyboardButtonTapped(buttonNumber: NSInteger) {
        // If backspace tapped, remove last char. Else, append new char.
        if buttonNumber == -1 {
            codeTextField.removeNumber()
        } else {
            codeTextField.appendNumber(buttonNumber: buttonNumber)
        }
    }
}

// MARK: - AlertServiceDelegate
extension PINViewController : AlertServiceDelegate {
    func cancelHandler() {
        alertService.hide()
    }
    
    func actionHandler() {
        alertService.hide()
        self.navigationController?.popViewController(animated: true)
    }
}
