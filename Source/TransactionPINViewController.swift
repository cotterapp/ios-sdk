//
//  TransactionPINViewController.swift
//  CotterIOS
//
//  Created by Raymond Andrie on 2/4/20.
//

import UIKit

class TransactionPINViewController: UIViewController, KeyboardViewDelegate, PINBaseController {
    // pass config here by TransactionPINViewController.config = Config()
    var config: Config?
    
    let alertService = AlertService()
    var showErrorMsg = false
    var authService = LocalAuthService()
    
    // Constants
    let closeTitle = "Yakin tidak Mau Buat PIN Sekarang?"
    let closeMessage = "PIN Ini diperlukan untuk keamanan akunmu, lho."
    let stayText = "Input PIN"
    let leaveText = "Lain Kali"
    
    let showPinText = "Lihat PIN"
    let hidePinText = "Sembunyikan"
    
    @IBOutlet weak var pinVisibilityButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var keyboardView: KeyboardView!
    
    @IBOutlet weak var codeTextField: OneTimeCodeTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("loaded Transaction PIN View!")
        
        // Set-up
        addConfigs()
        addDelegates()
        instantiateCodeTextFieldFunctions()
        
        // TODO: Show Alert for Biometrics
        authService.authenticate(view: self, reason: "Verifikasi", callback: self.config?.callbackFunc)
    }
    
    func instantiateCodeTextFieldFunctions() {
        codeTextField.removeErrorMsg = {
            // Remove error msg if it is present
            if self.showErrorMsg {
                self.toggleErrorMsg()
            }
        }
        
        codeTextField.didEnterLastDigit = { code in
            print("PIN Code Entered: ", code)
            
            // If code has repeating digits, show error.
            let pattern = "\\b(\\d)\\1+\\b"
            let result = code.range(of: pattern, options: .regularExpression)
            if result != nil {
                self.toggleErrorMsg()
                return
            }
            
            // If code is straight number e.g. 123456, show error.
            if code == "123456" || code == "654321" {
                self.toggleErrorMsg()
                return
            }
            
            // Clear the text before continue
            self.codeTextField.clear()
            
            // TODO: Go to confirmation page
//            let confirmVC = self.storyboard?.instantiateViewController(withIdentifier: "PINConfirmViewController")as! PINConfirmViewController
//            confirmVC.prevCode = code
//            confirmVC.config = self.config
//            self.navigationController?.pushViewController(confirmVC, animated: true)
        }
    }
    
    // Make Configurations
    func addConfigs() {
    self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layoutIfNeeded()
        
        self.navigationItem.hidesBackButton = true
        let crossButton = UIBarButtonItem(title: "\u{2717}", style: UIBarButtonItem.Style.plain, target: self, action: #selector(TransactionPINViewController.promptClose(sender:)))
        crossButton.tintColor = UIColor.black
        self.navigationItem.leftBarButtonItem = crossButton
        
        configurePinVisButton()
        codeTextField.configure()
        configureErrorMsg()
    }
    
    // Add any delegates
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
        pinVisibilityButton.setTitle(showPinText, for: .normal)
    }
    
    func configureErrorMsg() {
        errorLabel.isHidden = true
    }
    
    func toggleErrorMsg() {
        showErrorMsg.toggle()
        errorLabel.isHidden.toggle()
    }
    
    @IBAction func onClickPinVis(_ sender: UIButton) {
        codeTextField.togglePinVisibility()
        if sender.title(for: .normal) == showPinText {
            sender.setTitle(hidePinText, for: .normal)
        } else {
            sender.setTitle(showPinText, for: .normal)
        }
    }
    
    @objc private func promptClose(sender: UIBarButtonItem) {
        let cancelHandler = {
            // Go back to previous screen
            self.navigationController?.popViewController(animated: true)
            return
        }
        
        // Perform Prompt Alert
        let alertVC = alertService.createDefaultAlert(title: closeTitle, body: closeMessage, actionText: stayText, cancelText: leaveText, cancelHandler: cancelHandler)
        
        present(alertVC, animated: true)
    }
    
    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
