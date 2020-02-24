//
//  UpdateCreateNewPINViewController.swift
//  CotterIOS
//
//  Created by Raymond Andrie on 2/8/20.
//

import UIKit

public class UpdateCreateNewPINViewControllerKey {
    // MARK: - Keys for Strings
    static let showPin = "UpdateCreateNewPINViewController/showPin"
    static let hidePin = "UpdateCreateNewPINViewController/hidePin"
}

class UpdateCreateNewPINViewController: UIViewController {
    // Pass config here by UpdateCreateNewPINViewController.config = Config()
    public var config: Config?
    // Pass oldCode here by UpdateCreateNewPINViewController.oldCode = code
    public var oldCode: String?
  
    typealias VCTextKey = UpdateCreateNewPINViewControllerKey
  
    let showPinText = CotterStrings.instance.getText(for: VCTextKey.showPin)
    let hidePinText = CotterStrings.instance.getText(for: VCTextKey.hidePin)
    
    @IBOutlet weak var pinVisibilityButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var codeTextField: OneTimeCodeTextField!
    
    @IBOutlet weak var keyboardView: KeyboardView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("loaded Update Create New PIN View!")
        
        // Set-up
        addConfigs()
        addDelegates()
        instantiateCodeTextFieldFunctions()
    }
    
    @IBAction func OnClickPinVis(_ sender: UIButton) {
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

// MARK: - KeyboardViewDelegate
extension UpdateCreateNewPINViewController : KeyboardViewDelegate {
    func keyboardButtonTapped(buttonNumber: NSInteger) {
        if buttonNumber == -1 {
            codeTextField.removeNumber()
        } else {
            codeTextField.appendNumber(buttonNumber: buttonNumber)
        }
    }
}

// MARK: - PINBaseController
extension UpdateCreateNewPINViewController : PINBaseController {
    func instantiateCodeTextFieldFunctions() {
        codeTextField.removeErrorMsg = {
            // Remove error msg if it is present
            if !self.errorLabel.isHidden {
                self.toggleErrorMsg(msg: nil)
            }
        }
        
        codeTextField.didEnterLastDigit = { code in
            print("PIN Code Entered: ", code)
            
            // If code has repeating digits, or is a straight number, or is the old code, show error.
            let pattern = "\\b(\\d)\\1+\\b"
            let result = code.range(of: pattern, options: .regularExpression)
            if result != nil || code == "123456" || code == "654321" {
                if self.errorLabel.isHidden {
                    self.toggleErrorMsg(msg: PinErrorMessages.badPIN)
                }
                return false
            }
            
            if code == self.oldCode {
                if self.errorLabel.isHidden {
                    self.toggleErrorMsg(msg: PinErrorMessages.similarPINAsBefore)
                }
                return false
            }
            
            self.codeTextField.clear()
            
            // Go to Confirm New Pin Page
            let updateConfirmPINVC = self.storyboard?.instantiateViewController(withIdentifier: "UpdateConfirmNewPINViewController")as! UpdateConfirmNewPINViewController
            updateConfirmPINVC.prevCode = code
            updateConfirmPINVC.oldCode = self.oldCode!
            updateConfirmPINVC.config = self.config
            self.navigationController?.pushViewController(updateConfirmPINVC, animated: true)
            return true
        }
    }
    
    func addConfigs() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layoutIfNeeded()
        
        self.navigationItem.hidesBackButton = true
        let backButton = UIBarButtonItem(title: "\u{2190}", style: UIBarButtonItem.Style.plain, target: self, action: #selector(UpdateCreateNewPINViewController.promptBack(sender:)))
        backButton.tintColor = UIColor.black
        self.navigationItem.leftBarButtonItem = backButton
        
        codeTextField.configure()
        configureErrorLabel()
        configurePinVisibilityButton()
    }
    
    func addDelegates() {
        self.keyboardView.delegate = self
    }
    
    func configurePinVisButton() {
        // No initial Error Msg
        pinVisibilityButton.setTitle("", for: .normal)
    }
    
    func configureErrorLabel() {
        errorLabel.isHidden = true
        errorLabel.textColor = Config.instance.colors.danger
    }
  
  func configurePinVisibilityButton() {
      pinVisibilityButton.setTitle(showPinText, for: .normal)
      pinVisibilityButton.setTitleColor(Config.instance.colors.primary, for: .normal)
  }
    
    func toggleErrorMsg(msg: String?) {
        errorLabel.isHidden.toggle()
        if !errorLabel.isHidden {
            errorLabel.text = msg
        }
    }
    
    @objc private func promptBack(sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
}
