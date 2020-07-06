//
//  UpdateCreateNewPINViewController.swift
//  CotterIOS
//
//  Created by Raymond Andrie on 2/8/20.
//

import UIKit

// MARK: - Keys for Strings
public class UpdateCreateNewPINViewControllerKey {
    static let navTitle = "UpdateCreateNewPINViewController/navTitle"
    static let title = "UpdateCreateNewPINViewController/title"
    static let showPin = "UpdateCreateNewPINViewController/showPin"
    static let hidePin = "UpdateCreateNewPINViewController/hidePin"
}

// MARK: - Presenter Protocol delegated UI-related logic
protocol UpdateCreateNewPINViewPresenter {
    func onViewLoaded()
    func onClickPinVis(button: UIButton)
}

// MARK: - Properties of UpdateCreateNewPINViewController
struct UpdateCreateNewPINViewProps {
    let navTitle: String
    let title: String
    let showPinText: String
    let hidePinText: String
    
    let primaryColor: UIColor
    let accentColor: UIColor
    let dangerColor: UIColor
}

// MARK: - Components of UpdateCreateNewPINViewController
protocol UpdateCreateNewPINViewComponent: AnyObject {
    func setupUI()
    func setupDelegates()
    func render(_ props: UpdateCreateNewPINViewProps)
    func togglePinVisibility(button: UIButton, showPinText: String, hidePinText: String)
}

// MARK: - UpdateCreateNewPINViewPresenter Implementation
class UpdateCreateNewPINViewPresenterImpl: UpdateCreateNewPINViewPresenter {
    
    typealias VCTextKey = UpdateCreateNewPINViewControllerKey
    
    weak var viewController: UpdateCreateNewPINViewComponent!
    
    let props: UpdateCreateNewPINViewProps = {
        // MARK: - VC Text Definitions
        let navTitle = CotterStrings.instance.getText(for: VCTextKey.navTitle)
        let titleText = CotterStrings.instance.getText(for: VCTextKey.title)
        let showPinText = CotterStrings.instance.getText(for: VCTextKey.showPin)
        let hidePinText = CotterStrings.instance.getText(for: VCTextKey.hidePin)
        
        // MARK: - VC Color Definitions
        let primaryColor = Config.instance.colors.primary
        let accentColor = Config.instance.colors.accent
        let dangerColor = Config.instance.colors.danger
        
        return UpdateCreateNewPINViewProps(navTitle: navTitle, title: titleText, showPinText: showPinText, hidePinText: hidePinText, primaryColor: primaryColor, accentColor: accentColor, dangerColor: dangerColor)
    }()
    
    init(_ viewController: UpdateCreateNewPINViewComponent) {
        self.viewController = viewController
    }
    
    func onViewLoaded() {
        viewController.setupUI()
        viewController.setupDelegates()
        viewController.render(props)
    }
    
    func onClickPinVis(button: UIButton) {
        viewController.togglePinVisibility(button: button, showPinText: props.showPinText, hidePinText: props.hidePinText)
    }
    
}

class UpdateCreateNewPINViewController: UIViewController {
    // Pass oldCode here by UpdateCreateNewPINViewController.oldCode = code
    var oldCode: String?
    
    @IBOutlet weak var pinVisibilityButton: UIButton!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var codeTextField: OneTimeCodeTextField!
    
    @IBOutlet weak var keyboardView: KeyboardView!

    lazy var presenter: UpdateCreateNewPINViewPresenter = UpdateCreateNewPINViewPresenterImpl(self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("loaded Update Create New PIN View!")
        
        // Set-up
        presenter.onViewLoaded()
        instantiateCodeTextFieldFunctions()
    }
    
    @IBAction func onClickPinVis(_ sender: UIButton) {
        presenter.onClickPinVis(button: sender)
    }
    
    func toggleErrorMsg(msg: String?) {
        errorLabel.isHidden.toggle()
        if !errorLabel.isHidden {
            errorLabel.text = msg
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
            
            // Ensure consecutive PIN number is rejected
            if result != nil || self.findSequence(sequenceLength: code.count, in: code) {
                if self.errorLabel.isHidden {
                    self.toggleErrorMsg(msg: CotterStrings.instance.getText(for: PinErrorMessagesKey.badPin))
                }
                return false
            }
            
            // if new code is similar as previous code
            if code == self.oldCode {
                if self.errorLabel.isHidden {
                    self.toggleErrorMsg(msg: CotterStrings.instance.getText(for: PinErrorMessagesKey.similarPinAsBefore))
                }
                return false
            }
            
            self.codeTextField.clear()
            
            // Go to Confirm New Pin Page
            let updateConfirmPINVC = self.storyboard?.instantiateViewController(withIdentifier: "UpdateConfirmNewPINViewController")as! UpdateConfirmNewPINViewController
            updateConfirmPINVC.prevCode = code
            updateConfirmPINVC.oldCode = self.oldCode!
            self.navigationController?.pushViewController(updateConfirmPINVC, animated: true)
            return true
        }
    }
}

// MARK: - UpdateCreateNewPINViewComponent Instantiations
extension UpdateCreateNewPINViewController: UpdateCreateNewPINViewComponent {
    func setupUI() {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
//        self.navigationItem.hidesBackButton = true
//        let backButton = UIBarButtonItem(title: "\u{2190}", style: UIBarButtonItem.Style.plain, target: self, action: #selector(UpdateCreateNewPINViewController.promptBack(sender:)))
//        backButton.tintColor = UIColor.black
//        self.navigationItem.leftBarButtonItems = [backButton]
        
        errorLabel.isHidden = true
        
        codeTextField.configure()
    }
    
    @objc private func promptBack(sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setupDelegates() {
        self.keyboardView.delegate = self
    }
    
    func render(_ props: UpdateCreateNewPINViewProps) {
        setupLeftTitleBar(with: props.navTitle)
        titleLabel.text = props.title
        titleLabel.font = Config.instance.fonts.title
        pinVisibilityButton.setTitle(props.showPinText, for: .normal)
        pinVisibilityButton.setTitleColor(props.primaryColor, for: .normal)
        pinVisibilityButton.titleLabel?.font = Config.instance.fonts.subtitle
        errorLabel.textColor = props.dangerColor
        errorLabel.font = Config.instance.fonts.paragraph
    }
    
    func togglePinVisibility(button: UIButton, showPinText: String, hidePinText: String) {
        codeTextField.togglePinVisibility()
        if button.title(for: .normal) == showPinText {
            button.setTitle(hidePinText, for: .normal)
        } else {
            button.setTitle(showPinText, for: .normal)
        }
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
