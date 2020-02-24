//
//  UpdatePINViewController.swift
//  CotterIOS
//
//  Created by Raymond Andrie on 2/8/20.
//

import UIKit

public class UpdatePINViewControllerKey {
    // MARK: - Keys for Strings
    static let navTitle = "UpdatePINViewControllerKey/navTitle"
    static let showPin = "UpdatePINViewControllerKey/showPin"
    static let hidePin = "UpdatePINViewControllerKey/hidePin"
    static let title = "UpdatePINViewControllerKey/title"
}

class UpdatePINViewController: UIViewController, KeyboardViewDelegate, PINBaseController {
    typealias VCTextKey = UpdatePINViewControllerKey
    
    var authService: LocalAuthService = LocalAuthService()
    
    // Pass config here by UpdatePINViewController.config = Config()
    public var config: Config?
    
    // MARK: - VC Text Definitions
    let navTitle = CotterStrings.instance.getText(for: VCTextKey.navTitle)
    let showPinText = CotterStrings.instance.getText(for: VCTextKey.showPin)
    let hidePinText = CotterStrings.instance.getText(for: VCTextKey.hidePin)
    let viewTitle = CotterStrings.instance.getText(for: VCTextKey.title)
    
    // MARK: - Color Text Definitions
    let hexTitleColor = CotterColors.instance.getColor(for: UpdateProfileColorVCKey.pinTitleColor)
    let hexButtonColor = CotterColors.instance.getColor(for: UpdateProfileColorVCKey.pinButtonColor)
    let hexEmptyPinColor = CotterColors.instance.getColor(for: UpdateProfileColorVCKey.pinEmptyColor)
    let hexErrorColor = CotterColors.instance.getColor(for: UpdateProfileColorVCKey.pinErrorColor)
    let hexInputPinColor = CotterColors.instance.getColor(for: UpdateProfileColorVCKey.pinInputColor)
    
    @IBOutlet weak var pinVisibilityButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var codeTextField: OneTimeCodeTextField!
    
    @IBOutlet weak var keyboardView: KeyboardView!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("loaded Update Profile PIN View!")
        
        // Set-up
        addConfigs()
        addDelegates()
        instantiateCodeTextFieldFunctions()
        
        // Text setup
        populateText()
        setTextColors()
    }
    
    func populateText() {
        self.navigationItem.title = navTitle
        self.titleLabel.text = viewTitle
        self.pinVisibilityButton.setTitle(showPinText, for: .normal)
    }
    
    func setTextColors() {
        // VC Colors
        self.titleLabel.textColor = UIColor(hexString: hexTitleColor)
        self.pinVisibilityButton.setTitleColor(UIColor(hexString: hexButtonColor), for: .normal)
        self.errorLabel.textColor = UIColor(hexString: hexErrorColor)
        
        // Code Text Field Colors
        self.codeTextField.setColors(
            defaultColor: UIColor(hexString: hexEmptyPinColor),
            inputColor: UIColor(hexString: hexInputPinColor),
            errorColor: UIColor(hexString: hexErrorColor)
        )
    }
    
    func instantiateCodeTextFieldFunctions() {
        codeTextField.removeErrorMsg = {
            // Remove error msg if it is present
            if !self.errorLabel.isHidden {
                self.toggleErrorMsg(msg: nil)
            }
        }
        
        codeTextField.didEnterLastDigit = { code in
            print("PIN Code Entered: ", code)
            
            // If code has repeating digits or is a straight number, show error.
            let pattern = "\\b(\\d)\\1+\\b"
            let result = code.range(of: pattern, options: .regularExpression)
            if result != nil || code == "123456" || code == "654321" {
                if self.errorLabel.isHidden {
                    self.toggleErrorMsg(msg: PinErrorMessages.badPIN)
                }
                return false
            }
            
            func pinVerificationCallback(success: Bool) {
                if success {
                    self.codeTextField.clear()
                    // Go to Create New PIN View
                    let updateCreatePINVC = self.storyboard?.instantiateViewController(withIdentifier: "UpdateCreateNewPINViewController")as! UpdateCreateNewPINViewController
                    updateCreatePINVC.oldCode = code
                    updateCreatePINVC.config = self.config
                    self.navigationController?.pushViewController(updateCreatePINVC, animated: true)
                } else {
                    if self.errorLabel.isHidden {
                        self.toggleErrorMsg(msg: PinErrorMessages.incorrectPIN)
                    }
                }
            }
            
            // Verify PIN through API
            do {
                _ = try self.authService.pinAuth(pin: code, event:"UPDATE", callback: pinVerificationCallback)
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
        configureErrorMsg()
    }
    
    func addDelegates() {
        self.keyboardView.delegate = self
    }
    
    func keyboardButtonTapped(buttonNumber: NSInteger) {
        if buttonNumber == -1 {
            codeTextField.removeNumber()
        } else {
            codeTextField.appendNumber(buttonNumber: buttonNumber)
        }
    }
    
    func configureErrorMsg() {
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
        if sender.title(for: .normal) == showPinText {
            sender.setTitle(hidePinText, for: .normal)
        } else {
            sender.setTitle(showPinText, for: .normal)
        }
    }
    
    @objc private func promptBack(sender: UIBarButtonItem) {
        // Go back to previous screen
        self.navigationController?.popViewController(animated: true)
    }
    
    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
