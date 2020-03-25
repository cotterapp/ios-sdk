//
//  ResetConfirmPINViewController.swift
//  Cotter
//
//  Created by Raymond Andrie on 3/22/20.
//

import UIKit

public class ResetConfirmPINViewControllerKey {
    // MARK: - Keys for Strings
    static let navTitle = "ResetConfirmPINViewController/navTitle"
    static let title = "ResetConfirmPINViewController/title"
    static let showPin = "ResetConfirmPINViewController/showPin"
    static let hidePin = "ResetConfirmPINViewController/hidePin"
}

class ResetConfirmPINViewController: UIViewController {
    // prevCode should be passed from the previous (PINView) controller
    var prevCode: String?
    
    typealias VCTextKey = ResetConfirmPINViewControllerKey
    
    // MARK: - VC Text Definitions
    let navTitle = CotterStrings.instance.getText(for: VCTextKey.navTitle)
    let titleText = CotterStrings.instance.getText(for: VCTextKey.title)
    let showPinText = CotterStrings.instance.getText(for: VCTextKey.showPin)
    let hidePinText = CotterStrings.instance.getText(for: VCTextKey.hidePin)
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var codeTextField: OneTimeCodeTextField!
    
    @IBOutlet weak var pinVisibilityButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var keyboardView: KeyboardView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("loaded PIN Reset Confirmation View!")
        
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
extension ResetConfirmPINViewController : PINBaseController {
    func instantiateCodeTextFieldFunctions() {
        codeTextField.removeErrorMsg = {
            // Remove error msg if it is present
            if !self.errorLabel.isHidden {
                self.toggleErrorMsg(msg: nil)
            }
        }
        
        codeTextField.didEnterLastDigit = { code in
            print("PIN Code Entered: ", code)
            
            if self.prevCode == nil {
                print("No previous code exists!")
                return false
            }
            
            // If the entered digits are not the same, show error.
            if code != self.prevCode! {
                if self.errorLabel.isHidden {
                    self.toggleErrorMsg(msg: CotterStrings.instance.getText(for: PinErrorMessagesKey.incorrectPinConfirmation))
                }
                return false
            }
            
            // If code has repeating digits or is a straight number, show error.
            let pattern = "\\b(\\d)\\1+\\b"
            let result = code.range(of: pattern, options: .regularExpression)
            if result != nil || self.findSequence(sequenceLength: code.count, in: code) {
                if self.errorLabel.isHidden {
                    self.toggleErrorMsg(msg: CotterStrings.instance.getText(for: PinErrorMessagesKey.badPin))
                }
                return false
            }
            
            guard let resetCode = Config.instance.userInfo?.resetCode, let resetChallengeID = Config.instance.userInfo?.resetChallengeID,
                let resetChallenge = Config.instance.userInfo?.resetChallenge else {
                    // Display Error
                    if self.errorLabel.isHidden {
                        self.toggleErrorMsg(msg: CotterStrings.instance.getText(for: PinErrorMessagesKey.resetPinFailed))
                    }
                    return false
            }
            
//            // Remove after
//            let resetPINFinalVC = self.storyboard?.instantiateViewController(withIdentifier: "ResetPINFinalViewController")as! ResetPINFinalViewController
//            self.navigationController?.pushViewController(resetPINFinalVC, animated: true)
            
            // Define the Reset New PIN Callback
            func resetPinCb(response: CotterResult<CotterBasicResponse>) {
                switch response {
                case .success(let data):
                    if data.success {
                        self.codeTextField.clear()
                        // Clear Reset Information after success
                        Config.instance.userInfo?.clearResetInfo()
                        // Go to Reset PIN Final View
                        let resetPINFinalVC = self.storyboard?.instantiateViewController(withIdentifier: "ResetPINFinalViewController")as! ResetPINFinalViewController
                        self.navigationController?.pushViewController(resetPINFinalVC, animated: true)
                    } else {
                        // Display Error
                        if self.errorLabel.isHidden {
                            self.toggleErrorMsg(msg: CotterStrings.instance.getText(for: PinErrorMessagesKey.resetPinFailed))
                        }
                    }
                case .failure(let err):
                    // we can handle multiple error results here
                    print(err.localizedDescription)
                    
                    // Display Error
                    if self.errorLabel.isHidden {
                        self.toggleErrorMsg(msg: CotterStrings.instance.getText(for: PinErrorMessagesKey.resetPinFailed))
                    }
                }
            }
            
            CotterAPIService.shared.resetPIN(
                resetCode: resetCode,
                newCode: code,
                challengeID: resetChallengeID,
                challenge: resetChallenge,
                cb: resetPinCb
            )
            
            return true
        }
    }
  
    func addConfigs() {
        self.navigationItem.hidesBackButton = true
        let backButton = UIBarButtonItem(title: "\u{2190}", style: UIBarButtonItem.Style.plain, target: self, action: #selector(navigateBack(sender:)))
        backButton.tintColor = UIColor.black
        self.navigationItem.leftBarButtonItem = backButton
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layoutIfNeeded()
        
        codeTextField.configure()
        configureText()
        configureErrorLabel()
        configureButtons()
    }
    
    func addDelegates() {
        self.keyboardView.delegate = self
    }
    
    func configureText() {
        self.navigationItem.title = navTitle
        self.titleLabel.text = titleText
    }
    
    func configureButtons() {
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
    
    @objc private func navigateBack(sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - KeyboardViewDelegate
extension ResetConfirmPINViewController : KeyboardViewDelegate {
    func keyboardButtonTapped(buttonNumber: NSInteger) {
        // If backspace tapped, remove last char. Else, append new char.
        if buttonNumber == -1 {
            print("removing number")
            codeTextField.removeNumber()
        } else {
            codeTextField.appendNumber(buttonNumber: buttonNumber)
        }
    }
}
