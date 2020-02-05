//
//  PINViewController.swift
//  CotterIOS
//
//  Created by Albert Purnama on 2/2/20.
//

import Foundation
import UIKit

class PINViewController : UIViewController, KeyboardViewDelegate {
    // pass config here by PINViewController.config = Config()
    var config: Config?
    
    // Alert Service
    let alertService = AlertService()
    let closeTitle = "Yakin tidak Mau Buat PIN Sekarang?"
    let closeMessage = "PIN Ini diperlukan untuk keamanan akunmu, lho."
    let stayText = "Input PIN"
    let leaveText = "Lain Kali"
    
    // Code Text Field
    @IBOutlet weak var codeTextField: OneTimeCodeTextField!
    
    // PIN Visibility Toggle Button
    @IBOutlet weak var pinVisibilityButton: UIButton!
    let showPinText = "Lihat PIN"
    let hidePinText = "Sembunyikan"
    
    // Error Label
    @IBOutlet weak var errorLabel: UILabel!
    var showErrorMsg = false
    
    // Keyboard
    @IBOutlet weak var keyboardView: KeyboardView!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("loaded PIN Cotter View")
        
        // Connect the Keyboard View Delegate
        self.keyboardView.delegate = self
        
        // Implement Custom Back Button instead of default in Nav controller
        self.navigationItem.hidesBackButton = true
        let crossButton = UIBarButtonItem(title: "\u{2717}", style: UIBarButtonItem.Style.plain, target: self, action: #selector(PINViewController.promptClose(sender:)))
        crossButton.tintColor = UIColor.black
        self.navigationItem.leftBarButtonItem = crossButton
        
        // Remove default Nav controller styling
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layoutIfNeeded()
        
        // Configure PIN Visibility Button
        configurePinVisButton()
        
        // Add Password Code Text Field
        codeTextField.configure()
        
        // Configure Error Msg Label
        configureErrorMsg()
        
        // Instantiate Function to run when user enters wrong PIN code
        codeTextField.removeErrorMsg = {
            // Remove error msg if it is present
            if self.showErrorMsg {
                self.toggleErrorMsg()
            }
        }
        
        // Instantiate Function to run when PIN is fully entered
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
            
            // Go to confirmation page
            let confirmVC = self.storyboard?.instantiateViewController(withIdentifier: "PINConfirmViewController")as! PINConfirmViewController
            confirmVC.prevCode = code
            confirmVC.config = self.config
            self.navigationController?.pushViewController(confirmVC, animated: true)
        }
    }
    
    // This delegate function runs when the buttons in keyboardView is tapped.
    // Code Text Field is updated here.
    func keyboardButtonTapped(buttonNumber: NSInteger) {
        // If backspace tapped, remove last char. Else, append new char.
        if buttonNumber == -1 {
            codeTextField.removeNumber()
        } else {
            codeTextField.appendNumber(buttonNumber: buttonNumber)
        }
    }
    
    private func configurePinVisButton() {
        pinVisibilityButton.setTitleColor(UIColor(red: 0.0196, green: 0.4275, blue: 0, alpha: 1.0), for: .normal)
        pinVisibilityButton.setTitle(showPinText, for: .normal)
        pinVisibilityButton.isHidden = false
    }
    
    private func configureErrorMsg() {
        errorLabel.isHidden = true
        errorLabel.textColor = UIColor(red: 0.8392, green: 0, blue: 0, alpha: 1.0)
    }
    
    private func toggleErrorMsg() {
        showErrorMsg.toggle()
        errorLabel.isHidden.toggle()
        pinVisibilityButton.isHidden.toggle()
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
        // Perform Prompt Alert
        let cancelHandler = {
            // Go back to previous screen
            self.navigationController?.popViewController(animated: true)
            return
        }
        
        let alertVC = alertService.createDefaultAlert(title: closeTitle, body: closeMessage, actionText: stayText, cancelText: leaveText, cancelHandler: cancelHandler)
        
        present(alertVC, animated: true)
    }
    
    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
