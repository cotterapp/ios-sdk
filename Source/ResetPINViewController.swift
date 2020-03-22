//
//  ResetPINViewController.swift
//  Cotter
//
//  Created by Raymond Andrie on 3/19/20.
//

import UIKit

public class ResetPINViewControllerKey {
    // MARK: - Keys for Strings
   static let navTitle = "ResetPINViewController/navTitle"
   static let title = "ResetPINViewController/title"
   static let subtitle = "ResetPINViewController/subtitle"
   static let resendEmail = "ResetPINViewController/resendEmail"
}

class ResetPINViewController: UIViewController {
    var authService = LocalAuthService()
    
    typealias VCTextKey = ResetPINViewControllerKey
    
    var hideCloseButton: Bool = false
    
    // MARK: - VC Text Definitions
    
    
    @IBOutlet weak var resetPinTitle: UILabel!
    
    @IBOutlet weak var resetPinSubtitle: UILabel!
    
    @IBOutlet weak var resetCodeTextField: ResetCodeTextField!
    
    @IBOutlet weak var resetPinError: UILabel!
    
    @IBOutlet weak var resendEmailButton: UIButton!
    
    @IBOutlet weak var keyboardView: KeyboardView!
    
    override func viewDidAppear(_ animated: Bool) {
        // MARK: - Call start up functions here
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        addConfigs()
        addDelegates()
        instantiateCodeTextFieldFunctions()
    }

    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ResetPINViewController {
    func instantiateCodeTextFieldFunctions() {
        resetCodeTextField.removeErrorMsg = {
            // Remove error msg if it is present
            if !self.resetPinError.isHidden {
                self.toggleErrorMsg(msg: nil)
            }
        }
        
        resetCodeTextField.didEnterLastDigit = { code in
            print("PIN Code Entered: ", code)
            
            // Testing for Error below
            if code == "1234" {
                if self.resetPinError.isHidden {
                    self.toggleErrorMsg(msg: "Wrong Pin!")
                }
                return false
            }
            
            // Callback Function to execute after PIN Verification
            func pinResetCallback(success: Bool) {
                if success {
                    self.resetCodeTextField.clear()
                    // Go to Reset New PIN View
                    let resetNewPINVC = self.storyboard?.instantiateViewController(withIdentifier: "ResetNewPINViewController")as! ResetNewPINViewController
                    self.navigationController?.pushViewController(resetNewPINVC, animated: true)
                } else {
                    if self.resetPinError.isHidden {
                        // TODO: Toggle Pin Error
//                        self.toggleErrorMsg(msg: CotterStrings.instance.getText(for: PinErrorMessagesKey.incorrectPinVerification))
                        self.toggleErrorMsg(msg: "Pin Error!")
                    }
                }
            }
            
            // TODO: Check 4-Digit Verification Code through API
//            do {
//                _ = try self.authService.pinAuth(pin: code, event: "TRANSACTION", callback: pinVerificationCallback)
//            } catch let e {
//                print(e)
//                return false
//            }
            
            // clear the field
            self.resetCodeTextField.clear()
            

            let resetNewPINVC = self.storyboard?.instantiateViewController(withIdentifier: "ResetNewPINViewController")as! ResetNewPINViewController
            self.navigationController?.pushViewController(resetNewPINVC, animated: true)

            return true
        }
    }
    
    func addConfigs() {
        // Implement the Custom Back Button instead of default in Nav Controller
        self.navigationItem.hidesBackButton = true
        
        let crossButton = UIBarButtonItem(title: "\u{2190}", style: UIBarButtonItem.Style.plain, target: self, action: #selector(promptClose(sender:)))
        crossButton.tintColor = UIColor.black
        self.navigationItem.leftBarButtonItem = crossButton
        
        // Remove default Nav controller styling
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layoutIfNeeded()
        
        resetCodeTextField.configure()
        configureErrorLabel()
    }
    
    func addDelegates() {
        self.keyboardView.delegate = self
    }
    
    func configureErrorLabel() {
        resetPinError.isHidden = true
        resetPinError.textColor = Config.instance.colors.danger
    }
    
    func toggleErrorMsg(msg: String?) {
        resetPinError.isHidden.toggle()
        if !resetPinError.isHidden {
            resetPinError.text = msg
        }
    }
    
    @objc private func promptClose(sender: UIBarButtonItem) {
        // Go back to previous screen
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - KeyboardViewDelegate
extension ResetPINViewController : KeyboardViewDelegate {
    func keyboardButtonTapped(buttonNumber: NSInteger) {
        if buttonNumber == -1 {
            resetCodeTextField.removeNumber()
        } else {
            resetCodeTextField.appendNumber(buttonNumber: buttonNumber)
        }
    }
}
