//
//  ResetNewPINViewController.swift
//  Cotter
//
//  Created by Raymond Andrie on 3/22/20.
//

import UIKit

// MARK: - Keys for Strings
public class ResetNewPINViewControllerKey {
    public static let navTitle = "ResetNewPINViewController/navTitle"
    public static let title = "ResetNewPINViewController/title"
    public static let showPin = "ResetNewPINViewController/showPin"
    public static let hidePin = "ResetNewPINViewController/hidePin"
}

// MARK: - Presenter Protocol delegated UI-related logic
protocol ResetNewPINViewPresenter {
    func onViewLoaded()
}

// MARK: - Properties of ResetNewPINViewController
struct ResetNewPINViewProps {
    let navTitle: String
    let title: String
    let showPinText: String
    let hidePinText: String
    
    let primaryColor: UIColor
    let accentColor: UIColor
    let dangerColor: UIColor
}

// MARK: - Components of ResetNewPINViewController
protocol ResetNewPINViewComponent: AnyObject {
    func setupUI()
    func setupDelegates()
    func render(_ props: ResetNewPINViewProps)
}

// MARK: - ResetNewPINViewPresenter Implementation
class ResetNewPINViewPresenterImpl: ResetNewPINViewPresenter {
    
    typealias VCTextKey = ResetNewPINViewControllerKey
    
    weak var viewController: ResetNewPINViewComponent!

    let props: ResetNewPINViewProps = {
        // MARK: - VC Text Definitions
        let navTitle = CotterStrings.instance.getText(for: VCTextKey.navTitle)
        let titleText = CotterStrings.instance.getText(for: VCTextKey.title)
        let showPinText = CotterStrings.instance.getText(for: VCTextKey.showPin)
        let hidePinText = CotterStrings.instance.getText(for: VCTextKey.hidePin)
        
        // MARK: - VC Color Definitions
        let primaryColor = Config.instance.colors.primary
        let accentColor = Config.instance.colors.accent
        let dangerColor = Config.instance.colors.danger
        
        return ResetNewPINViewProps(navTitle: navTitle, title: titleText, showPinText: showPinText, hidePinText: hidePinText, primaryColor: primaryColor, accentColor: accentColor, dangerColor: dangerColor)
    }()
    
    init(_ viewController: ResetNewPINViewComponent) {
        self.viewController = viewController
    }
    
    func onViewLoaded() {
        viewController.setupUI()
        viewController.setupDelegates()
        viewController.render(props)
    }
}

class ResetNewPINViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var codeTextField: OneTimeCodeTextField!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var keyboardView: KeyboardView!
    
    lazy var presenter: ResetNewPINViewPresenter = ResetNewPINViewPresenterImpl(self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set-up
        presenter.onViewLoaded()
        instantiateCodeTextFieldFunctions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar
            .tintColor = Config.instance.colors.navbarTint
    }
    
    func setError(msg: String?) {
        errorLabel.isHidden = msg == nil
        errorLabel.text = msg
    }
}

// MARK: - PINBaseController
extension ResetNewPINViewController : PINBaseController {
    func generateErrorMessageFrom(error: CotterError) -> String {
        return ""
    }
    
    func instantiateCodeTextFieldFunctions() {
        // Instantiate Function to run when user enters wrong PIN code
        codeTextField.removeErrorMsg = {
            self.setError(msg: nil)
        }
        
        // Instantiate Function to run when PIN is fully entered
        codeTextField.didEnterLastDigit = { code in
            // If code has repeating digits or is a straight number, show error.
            let pattern = "\\b(\\d)\\1+\\b"
            let result = code.range(of: pattern, options: .regularExpression)
            
            // Ensure consecutive PIN number is rejected
            if result != nil || self.findSequence(sequenceLength: code.count, in: code) {
                self.setError(msg: CotterStrings.instance.getText(for: PinErrorMessagesKey.badPin))
                return false
            }

            // Clear Code text Field before continuing
            self.codeTextField.clear()
            
            // Go to Reset PIN Confirmation Page
            let confirmVC = self.storyboard?.instantiateViewController(withIdentifier: "ResetConfirmPINViewController") as! ResetConfirmPINViewController
            confirmVC.prevCode = code
            self.navigationController?.pushViewController(confirmVC, animated: true)
            
            return true
        }
    }
    
}

// MARK: - ResetNewPINViewComponent Instantiations
extension ResetNewPINViewController: ResetNewPINViewComponent {
    func setupUI() {
        errorLabel.isHidden = true
        
        codeTextField.configure()
    }
    
    func setupDelegates() {
        self.keyboardView.delegate = self
    }
    
    func render(_ props: ResetNewPINViewProps) {
        self.setupLeftTitleBar(with: props.navTitle)
        titleLabel.text = props.title
        titleLabel.font = Config.instance.fonts.title
        titleLabel.textColor = Config.instance.colors.accent
        errorLabel.textColor = props.dangerColor
        errorLabel.font = Config.instance.fonts.paragraph
    }
}

// MARK: - KeyboardViewDelegate
extension ResetNewPINViewController : KeyboardViewDelegate {
    func keyboardButtonTapped(buttonNumber: NSInteger) {
        // If backspace tapped, remove last char. Else, append new char.
        if buttonNumber == -1 {
            codeTextField.removeNumber()
        } else {
            codeTextField.appendNumber(buttonNumber: buttonNumber)
        }
    }
}
