//
//  UpdateConfirmNewPINViewController.swift
//  CotterIOS
//
//  Created by Raymond Andrie on 2/8/20.
//

import UIKit

class UpdateConfirmNewPINViewController: UIViewController, KeyboardViewDelegate, PINBaseController {
    var showErrorMsg: Bool = false
    
    // Pass config here by UpdateConfirmNewPINViewController.config = Config()
    public var config: Config?
    // Pass prevCode here by UpdateConfirmNewPINViewController.prevCode = code
    public var prevCode: String?
    
    @IBOutlet weak var pinVisibilityButton: UIButton!
    
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
                    self.toggleErrorMsg(msg: PinErrorMessages.wrongPINConfirm)
                }
                return false
            }
            
            // If code has repeating digits or is a straight number, show error.
            let pattern = "\\b(\\d)\\1+\\b"
            let result = code.range(of: pattern, options: .regularExpression)
            if result != nil || code == "123456" || code == "654321" {
                if self.errorLabel.isHidden {
                    self.toggleErrorMsg(msg: PinErrorMessages.badPIN)
                }
                return false
            }
            
            // Define the callbacks
            func successCb(resp: String) -> Void {
                self.codeTextField.clear()
                // Go to PIN Final View
                let pinFinalVC = Cotter.cotterStoryboard.instantiateViewController(withIdentifier: "PINFinalViewController")as! PINFinalViewController
                 pinFinalVC.requireAuth = false
                self.navigationController?.pushViewController(pinFinalVC, animated: true)
            }
            
            func errorCb(err: String) -> Void {
                print(err)
                // Display Error
                if self.errorLabel.isHidden {
                    self.toggleErrorMsg(msg: PinErrorMessages.updatePINFailed)
                }
            }
            
            CotterAPIService.shared.updateUserPin(
                oldCode: self.prevCode!,
                newCode: code,
                successCb: successCb,
                errCb: errorCb
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
    
    func configurePinVisButton() {
        // No initial Error Msg
        pinVisibilityButton.setTitle("", for: .normal)
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
        if sender.title(for: .normal) == PinDisplayText.showPinText {
            sender.setTitle(PinDisplayText.hidePinText, for: .normal)
        } else {
            sender.setTitle(PinDisplayText.showPinText, for: .normal)
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
