//
//  UpdatePINViewController.swift
//  CotterIOS
//
//  Created by Raymond Andrie on 2/8/20.
//

import UIKit

public class UpdatePINViewControllerKey {
    // MARK: - Keys for Strings
    static let navTitle = "UpdatePINViewController/navTitle"
    static let title = "UpdatePINViewController/title"
    static let showPin = "UpdatePINViewController/showPin"
    static let hidePin = "UpdatePINViewController/hidePin"
}

class UpdatePINViewController: UIViewController {
    var authService: LocalAuthService = LocalAuthService()
  
    typealias VCTextKey = UpdatePINViewControllerKey
  
    // MARK: - VC Text Definitions
    let navTitle = CotterStrings.instance.getText(for: VCTextKey.navTitle)
    let titleText = CotterStrings.instance.getText(for: VCTextKey.title)
    let showPinText = CotterStrings.instance.getText(for: VCTextKey.showPin)
    let hidePinText = CotterStrings.instance.getText(for: VCTextKey.hidePin)
    
    // Pass config here by UpdatePINViewController.config = Config()
    public var config: Config?
    
    @IBOutlet weak var pinVisibilityButton: UIButton!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var codeTextField: OneTimeCodeTextField!
    
    @IBOutlet weak var keyboardView: KeyboardView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("loaded Update Profile PIN View!")
        
        // Set-up
        addConfigs()
        addDelegates()
        instantiateCodeTextFieldFunctions()
        setCotterStatusBarStyle()
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

// MARK: - KeyboardViewDelegate
extension UpdatePINViewController : KeyboardViewDelegate {
    func keyboardButtonTapped(buttonNumber: NSInteger) {
        if buttonNumber == -1 {
            codeTextField.removeNumber()
        } else {
            codeTextField.appendNumber(buttonNumber: buttonNumber)
        }
    }
}

// MARK: - PINBaseController
extension UpdatePINViewController : PINBaseController {
    func instantiateCodeTextFieldFunctions() {
        codeTextField.removeErrorMsg = {
            // Remove error msg if it is present
            if !self.errorLabel.isHidden {
                self.toggleErrorMsg(msg: nil)
            }
        }
        
        codeTextField.didEnterLastDigit = { code in
            print("PIN Code Entered: ", code)
            
            func pinVerificationCallback(success: Bool) {
                if success {
                    self.codeTextField.clear()
                    // Go to Create New PIN View
                    let updateCreatePINVC = self.storyboard?.instantiateViewController(withIdentifier: "UpdateCreateNewPINViewController")as! UpdateCreateNewPINViewController
                    updateCreatePINVC.oldCode = code
                    updateCreatePINVC.config = self.config
                    self.navigationController?.pushViewController(updateCreatePINVC, animated: true)
                } else {
                    // Pin Verification Failed
                    if self.errorLabel.isHidden {
                        self.toggleErrorMsg(msg: CotterStrings.instance.getText(for: PinErrorMessagesKey.incorrectPinVerification))
                    }
                }
            }
            
            // Verify PIN through API
            do {
                _ = try self.authService.pinAuth(pin: code, event: CotterEvents.Update, callback: pinVerificationCallback)
            } catch let e {
                print(e)
                return false
            }
            
            return true
        }
    }
    
    func addConfigs() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layoutIfNeeded()
        
        self.navigationItem.hidesBackButton = true
        let backButton = UIBarButtonItem(title: "\u{2190}", style: UIBarButtonItem.Style.plain, target: self, action: #selector(UpdatePINViewController.promptBack(sender:)))
        backButton.tintColor = UIColor.black
        self.navigationItem.leftBarButtonItem = backButton
        
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
    
    func configureErrorLabel() {
        errorLabel.isHidden = true
        errorLabel.textColor = Config.instance.colors.danger
    }
  
    func configureButtons() {
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
        // Go back to previous screen
        self.navigationController?.popViewController(animated: true)
    }
}
