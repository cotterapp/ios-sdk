//
//  UpdateConfirmNewPINViewController.swift
//  CotterIOS
//
//  Created by Raymond Andrie on 2/8/20.
//

import UIKit

public class UpdateConfirmNewPINViewControllerKey {
    // MARK: - Keys for Strings
    static let navTitle = "UpdateConfirmNewPINViewController/navTitle"
    static let title = "UpdateConfirmNewPINViewController/title"
    static let showPin = "UpdateConfirmNewPINViewController/showPin"
    static let hidePin = "UpdateConfirmNewPINViewController/hidePin"
}

class UpdateConfirmNewPINViewController: UIViewController {
    typealias VCTextKey = UpdateConfirmNewPINViewControllerKey
  
    // MARK: - VC Text Definitions
    let navTitle = CotterStrings.instance.getText(for: VCTextKey.navTitle)
    let titleText = CotterStrings.instance.getText(for: VCTextKey.title)
    let showPinText = CotterStrings.instance.getText(for: VCTextKey.showPin)
    let hidePinText = CotterStrings.instance.getText(for: VCTextKey.hidePin)
    
    // Pass config here by UpdateConfirmNewPINViewController.config = Config()
    public var config: Config?
    
    // Pass oldCode here
    public var oldCode: String?
    
    // Pass prevCode here by UpdateConfirmNewPINViewController.prevCode = code
    public var prevCode: String?
    
    @IBOutlet weak var pinVisibilityButton: UIButton!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var codeTextField: OneTimeCodeTextField!
    
    @IBOutlet weak var keyboardView: KeyboardView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("loaded Update Confirm New PIN View!")
        
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
extension UpdateConfirmNewPINViewController : PINBaseController {
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
            
            // If code is not the same as previous code, show error.
            if code != self.prevCode {
                if self.errorLabel.isHidden {
                    self.toggleErrorMsg(msg: CotterStrings.instance.getText(for: PinErrorMessagesKey.incorrectPinConfirmation))
                }
                return false
            }
            
            // If code has repeating digits or is a straight number, show error.
            let pattern = "\\b(\\d)\\1+\\b"
            let result = code.range(of: pattern, options: .regularExpression)
            if result != nil || code == "123456" || code == "654321" {
                if self.errorLabel.isHidden {
                    self.toggleErrorMsg(msg: CotterStrings.instance.getText(for: PinErrorMessagesKey.badPin))
                }
                return false
            }
            
            // Define the callbacks
            func successCb(resp: Data?) -> Void {
                self.codeTextField.clear()
                // Go to PIN Final View
                let pinFinalVC = Cotter.cotterStoryboard.instantiateViewController(withIdentifier: "PINFinalViewController")as! PINFinalViewController
                 pinFinalVC.requireAuth = false
                self.navigationController?.pushViewController(pinFinalVC, animated: true)
            }
            
            func errorCb(err: Error?) -> Void {
                print(err?.localizedDescription ?? "error in UpdateViewController http request")
                // Display Error
                if self.errorLabel.isHidden {
                    self.toggleErrorMsg(msg: CotterStrings.instance.getText(for: PinErrorMessagesKey.updatePinFailed))
                }
            }
            
            // define the handlers, attach the callbacks
            let h = CotterCallback()
            h.successfulFunc = successCb
            h.networkErrorFunc = errorCb
            
            // Run API to update PIN
            CotterAPIService.shared.updateUserPin(
                oldCode: self.oldCode!,
                newCode: code,
                cb: h
            )
            
            return true
        }
    }
    
    func addConfigs() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layoutIfNeeded()
        
        self.navigationItem.hidesBackButton = true
        let backButton = UIBarButtonItem(title: "\u{2190}", style: UIBarButtonItem.Style.plain, target: self, action: #selector(UpdateConfirmNewPINViewController.promptBack(sender:)))
        backButton.tintColor = UIColor.black
        self.navigationItem.leftBarButtonItem = backButton
        
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
        // Go back to previous screen
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - KeyboardViewDelegate
extension UpdateConfirmNewPINViewController : KeyboardViewDelegate {
    func keyboardButtonTapped(buttonNumber: NSInteger) {
        if buttonNumber == -1 {
            codeTextField.removeNumber()
        } else {
            codeTextField.appendNumber(buttonNumber: buttonNumber)
        }
    }
}
