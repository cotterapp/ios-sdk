//
//  ResetNewPINViewController.swift
//  Cotter
//
//  Created by Raymond Andrie on 3/22/20.
//

import UIKit

// TODO: Add Reset New Pin VC Text Keys and add to typealias

class ResetNewPINViewController: UIViewController {
    
    // TODO: Replace this
    typealias VCTextKey = PINViewControllerKey
    
    var hideCloseButton: Bool = false
    
    // MARK: - VC Text Definitions
    let navTitle = CotterStrings.instance.getText(for: VCTextKey.navTitle)
    let showPinText = CotterStrings.instance.getText(for: VCTextKey.showPin)
    let hidePinText = CotterStrings.instance.getText(for: VCTextKey.hidePin)
    let titleText = CotterStrings.instance.getText(for: VCTextKey.title)
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var codeTextField: OneTimeCodeTextField!
    
    @IBOutlet weak var pinVisibilityButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var keyboardView: KeyboardView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set-up
        addConfigs()
        addDelegates()
        instantiateCodeTextFieldFunctions()
    }
    
    @IBAction func onClickPinVis(_ sender: UIButton) {
        codeTextField.togglePinVisibility()
        if sender.title(for: .normal) == showPinText {
            sender.setTitle(hidePinText, for: .normal)
        } else {
            sender.setTitle(showPinText, for: .normal)
        }
    }
    
    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: - PINBaseController
extension ResetNewPINViewController : PINBaseController {
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
                    self.toggleErrorMsg(msg: CotterStrings.instance.getText(for: PinErrorMessagesKey.badPin))
                }
                return false
            }

            // Clear Code text Field before continuing
            self.codeTextField.clear()
            
            // Go to Reset PIN Confirmation Page
            let confirmVC = self.storyboard?.instantiateViewController(withIdentifier: "ResetConfirmPINViewController") as! ResetConfirmPINViewController
            confirmVC.prevCode = code
            self.navigationController?.pushViewController(confirmVC, animated: true)
            
            return true
        }
    }
    
    func addConfigs() {
        // Implement Custom Back Button instead of default in Nav controller
        self.navigationItem.hidesBackButton = true
        
        // if close
        if !self.hideCloseButton {
            let crossButton = UIBarButtonItem(title: "\u{2717}", style: UIBarButtonItem.Style.plain, target: self, action: #selector(promptClose(sender:)))
            crossButton.tintColor = UIColor.black
            self.navigationItem.leftBarButtonItem = crossButton
        }
        
        // Remove default Nav controller styling
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layoutIfNeeded()
        
        codeTextField.configure()
        configureText()
        configureErrorLabel()
        configurePinVisibilityButton()
    }
    
    func addDelegates() {
        self.keyboardView.delegate = self
    }
    
    func configureText() {
        self.navigationItem.title = navTitle
        self.titleLabel.text = titleText
    }
    
    func configurePinVisibilityButton() {
        pinVisibilityButton.setTitle(showPinText, for: .normal)
        pinVisibilityButton.setTitleColor(Config.instance.colors.primary, for: .normal)
    }
    
    func configureErrorLabel() {
        errorLabel.isHidden = true
        errorLabel.textColor = Config.instance.colors.danger
    }
    
    func toggleErrorMsg(msg: String?) {
        errorLabel.isHidden.toggle()
        if !errorLabel.isHidden {
            errorLabel.text = msg
        }
    }
  
    @objc private func promptClose(sender: UIBarButtonItem) {
        // TODO: Go to Home Page?
    }
}

// MARK: - KeyboardViewDelegate
extension ResetNewPINViewController : KeyboardViewDelegate {
    func keyboardButtonTapped(buttonNumber: NSInteger) {
        // If backspace tapped, remove last char. Else, append new char.
        if buttonNumber == -1 {
            codeTextField.removeNumber()
        } else {
            codeTextField.appendNumber(buttonNumber: buttonNumber)
        }
    }
}
