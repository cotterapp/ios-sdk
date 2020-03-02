//
//  TransactionPINViewController.swift
//  CotterIOS
//
//  Created by Raymond Andrie on 2/4/20.
//

import UIKit

public class TransactionPINViewControllerKey {
    // MARK: - Keys for Strings
    static let navTitle = "TransactionPINViewController/navTitle"
    static let title = "TransactionPINViewController/title"
    static let showPin = "TransactionPINViewController/showPin"
    static let hidePin = "TransactionPINViewController/hidePin"
}

class TransactionPINViewController: UIViewController {
    var authService = LocalAuthService()
  
    typealias VCTextKey = TransactionPINViewControllerKey
    
    var hideCloseButton: Bool = false
    
    // MARK: - VC Text Definitions
    let navTitle = CotterStrings.instance.getText(for: VCTextKey.navTitle)
    let showPinText = CotterStrings.instance.getText(for: VCTextKey.showPin)
    let hidePinText = CotterStrings.instance.getText(for: VCTextKey.hidePin)
    let titleText = CotterStrings.instance.getText(for: VCTextKey.title)
    
    @IBOutlet weak var pinVisibilityButton: UIButton!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var keyboardView: KeyboardView!
    
    @IBOutlet weak var codeTextField: OneTimeCodeTextField!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("Transaction PIN View appeared!")
        
        CotterAPIService.shared.getBiometricStatus(cb: { response in
            switch response {
            case .success(let resp):
                if resp.enrolled {
                    let onFinishCallback = Config.instance.transactionCb
                    func cb(success: Bool) {
                        if success{
                            onFinishCallback("dummy biometric token", nil)
                        } else {
                            print("got here!")
                            self.toggleErrorMsg(msg: "Biometric is incorrect, please use PIN")
                        }
                    }
                    self.authService.bioAuth(view: self, event: "TRANSACTION", callback: cb)
                } else {
                    print("Biometric not enrolled")
                }
            case .failure(let err):
                print(err.localizedDescription)
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("loaded Transaction PIN View!")
        
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
extension TransactionPINViewController : PINBaseController {
    func instantiateCodeTextFieldFunctions() {
        codeTextField.removeErrorMsg = {
            // Remove error msg if it is present
            if !self.errorLabel.isHidden {
                self.toggleErrorMsg(msg: nil)
            }
        }
        
        codeTextField.didEnterLastDigit = { code in
            print("PIN Code Entered: ", code)
            
            let cbFunc = Config.instance.callbackFunc
            
            // Callback Function to execute after PIN Verification
            func pinVerificationCallback(success: Bool) {
                if success {
                    cbFunc("Token from Transaction PIN View!", nil)
                } else {
                    if self.errorLabel.isHidden {
                        self.toggleErrorMsg(msg: CotterStrings.instance.getText(for: PinErrorMessagesKey.incorrectPinVerification))
                    }
                }
            }
            
            // Verify PIN through API
            do {
                _ = try self.authService.pinAuth(pin: code, event: "TRANSACTION", callback: pinVerificationCallback)
            } catch let e {
                print(e)
                return false
            }
            
            // clear the field
            self.codeTextField.clear()

            return true
        }
    }
    
    // Make Configurations
    func addConfigs() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layoutIfNeeded()
        
        self.navigationItem.hidesBackButton = true

        if !self.hideCloseButton {
            let crossButton = UIBarButtonItem(title: "\u{2190}", style: UIBarButtonItem.Style.plain, target: self, action: #selector(TransactionPINViewController.promptClose(sender:)))
            crossButton.tintColor = UIColor.black
            self.navigationItem.leftBarButtonItem = crossButton
        }
        
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
  
    @objc private func promptClose(sender: UIBarButtonItem) {
//        alertService.show()
        // Go back to previous screen
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - KeyboardViewDelegate
extension TransactionPINViewController : KeyboardViewDelegate {
    func keyboardButtonTapped(buttonNumber: NSInteger) {
        if buttonNumber == -1 {
            codeTextField.removeNumber()
        } else {
            codeTextField.appendNumber(buttonNumber: buttonNumber)
        }
    }
}
