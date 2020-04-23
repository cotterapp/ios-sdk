//
//  PINConfirmViewController.swift
//  CotterIOS
//
//  Created by Albert Purnama on 2/2/20.
//

import UIKit

// MARK: - Keys for Strings
public class PINConfirmViewControllerKey {
    static let navTitle = "PINConfirmViewController/navTitle"
    static let showPin = "PINConfirmViewController/showPin"
    static let hidePin = "PINConfirmViewController/hidePin"
    static let title = "PINConfirmViewController/title"
}

// MARK: - Presenter Protocol delegated UI-related logic
protocol PINConfirmViewPresenter {
    func onViewLoaded()
    func onClickPinVis()
    func onToggleErrorMsg()
    func onInstantiateCodeTextFieldFunctions()
    func onAddConfigs()
    func onAddDelegates()
}

// MARK: - Properties of PINConfirmViewController
struct PINConfirmViewProps {
    let navTitle: String
    let showPinText: String
    let hidePinText: String
    let title: String
    
    let primaryColor: UIColor
    let accentColor: UIColor
    let dangerColor: UIColor
}

// MARK: - Component Protocol delegated to render props
protocol PINConfirmViewComponent: AnyObject {
    func render(_ props: PINConfirmViewProps)
}

class PINConfirmViewController : UIViewController {
    // prevCode should be passed from the previous (PINView) controller
    var prevCode: String?
    
    typealias VCTextKey = PINConfirmViewControllerKey
    
    let props: PINConfirmViewProps = {
        // MARK: - VC Text Definitions
        let navTitle = CotterStrings.instance.getText(for: VCTextKey.navTitle)
        let showPinText = CotterStrings.instance.getText(for: VCTextKey.showPin)
        let hidePinText = CotterStrings.instance.getText(for: VCTextKey.hidePin)
        let title = CotterStrings.instance.getText(for: VCTextKey.title)
        
        // MARK: - VC Color Definitions
        let primaryColor = Config.instance.colors.primary
        let accentColor = Config.instance.colors.accent
        let dangerColor = Config.instance.colors.danger
        
        return PINConfirmViewProps(navTitle: navTitle, showPinText: showPinText, hidePinText: hidePinText, title: title, primaryColor: primaryColor, accentColor: accentColor, dangerColor: dangerColor)
    }()
    
    // Code Text Field
    @IBOutlet weak var codeTextField: OneTimeCodeTextField!
    
    @IBOutlet weak var pinVisibilityButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var keyboardView: KeyboardView!
    
    var presenter: PINConfirmViewPresenter?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("loaded PIN Confirmation View!")
        
        // Set-up
        addConfigs()
        addDelegates()
        instantiateCodeTextFieldFunctions()
        render(props)
        
        presenter?.onViewLoaded()
    }
    
    @IBAction func onClickPinVis(_ sender: UIButton) {
        codeTextField.togglePinVisibility()
        if sender.title(for: .normal) == props.showPinText {
            sender.setTitle(props.hidePinText, for: .normal)
        } else {
            sender.setTitle(props.showPinText, for: .normal)
        }
        
        presenter?.onClickPinVis()
    }
    
    func toggleErrorMsg(msg: String?) {
        errorLabel.isHidden.toggle()
        if !errorLabel.isHidden {
            errorLabel.text = msg
        }
        
        presenter?.onToggleErrorMsg()
    }
}

// MARK: - PINBaseController
extension PINConfirmViewController : PINBaseController {
    func instantiateCodeTextFieldFunctions() {
        codeTextField.removeErrorMsg = {
            // Remove error msg if it is present
            if !self.errorLabel.isHidden {
                self.toggleErrorMsg(msg: nil)
            }
        }
        
        codeTextField.didEnterLastDigit = { code in
            print("PIN Code Entered: ", code)
            
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
            
            // define callback
            func enrollCb(response: CotterResult<CotterUser>) {
                switch response {
                case .success:
                    self.codeTextField.clear()
                    let finalVC = self.storyboard?.instantiateViewController(withIdentifier: "PINFinalViewController")as! PINFinalViewController
                    self.navigationController?.pushViewController(finalVC, animated: true)
                case .failure(let err):
                    // we can handle multiple error results here
                    print(err.localizedDescription)
                    
                    // Display Error
                    if self.errorLabel.isHidden {
                        self.toggleErrorMsg(msg: CotterStrings.instance.getText(for: PinErrorMessagesKey.enrollPinFailed))
                    }
                }
            }
            
            // Run API to enroll PIN
            CotterAPIService.shared.enrollUserPin(
                code: code,
                cb: enrollCb
            )
            
            return true
        }
        
        presenter?.onInstantiateCodeTextFieldFunctions()
    }
  
    func addConfigs() {
        self.navigationItem.hidesBackButton = true
        let backButton = UIBarButtonItem(title: "\u{2190}", style: UIBarButtonItem.Style.plain, target: self, action: #selector(navigateBack(sender:)))
        backButton.tintColor = UIColor.black
        self.navigationItem.leftBarButtonItem = backButton
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layoutIfNeeded()
        
        errorLabel.isHidden = true
        
        codeTextField.configure()
        
        presenter?.onAddConfigs()
    }
    
    func addDelegates() {
        self.keyboardView.delegate = self
        
        presenter?.onAddDelegates()
    }
    
    @objc private func navigateBack(sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - PINConfirmViewComponent Render
extension PINConfirmViewController : PINConfirmViewComponent {
    func render(_ props: PINConfirmViewProps) {
        navigationItem.title = props.navTitle
        titleLabel.text = props.title
        pinVisibilityButton.setTitle(props.showPinText, for: .normal)
        pinVisibilityButton.setTitleColor(props.primaryColor, for: .normal)
        errorLabel.textColor = props.dangerColor
    }
}

// MARK: - KeyboardViewDelegate
extension PINConfirmViewController : KeyboardViewDelegate {
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
