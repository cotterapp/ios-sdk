//
//  UpdateConfirmNewPINViewController.swift
//  CotterIOS
//
//  Created by Raymond Andrie on 2/8/20.
//

import UIKit

// MARK: - Keys for Strings
public class UpdateConfirmNewPINViewControllerKey {
    static let navTitle = "UpdateConfirmNewPINViewController/navTitle"
    static let title = "UpdateConfirmNewPINViewController/title"
    static let showPin = "UpdateConfirmNewPINViewController/showPin"
    static let hidePin = "UpdateConfirmNewPINViewController/hidePin"
}

// MARK: - Presenter Protocol delegated UI-related logic
protocol UpdateConfirmNewPINViewPresenter {
    func onViewLoaded()
    func onClickPinVis(button: UIButton)
}

// MARK: - Properties of UpdateConfirmNewPINViewController
struct UpdateConfirmNewPINViewProps {
    let navTitle: String
    let title: String
    let showPinText: String
    let hidePinText: String
    
    let primaryColor: UIColor
    let accentColor: UIColor
    let dangerColor: UIColor
}

// MARK: - Components of UpdateConfirmNewPINViewController
protocol UpdateConfirmNewPINViewComponent: AnyObject {
    func setupUI()
    func setupDelegates()
    func render(_ props: UpdateConfirmNewPINViewProps)
    func togglePinVisibility(button: UIButton, showPinText: String, hidePinText: String)
}

// MARK: - UpdateConfirmNewPINViewPresenter Implementation
class UpdateConfirmNewPINViewPresenterImpl: UpdateConfirmNewPINViewPresenter {
    
    typealias VCTextKey = UpdateConfirmNewPINViewControllerKey
    
    weak var viewController: UpdateConfirmNewPINViewComponent!
    
    let props: UpdateConfirmNewPINViewProps = {
        // MARK: - VC Text Definitions
        let navTitle = CotterStrings.instance.getText(for: VCTextKey.navTitle)
        let titleText = CotterStrings.instance.getText(for: VCTextKey.title)
        let showPinText = CotterStrings.instance.getText(for: VCTextKey.showPin)
        let hidePinText = CotterStrings.instance.getText(for: VCTextKey.hidePin)
        
        // MARK: - VC Color Definitions
        let primaryColor = Config.instance.colors.primary
        let accentColor = Config.instance.colors.accent
        let dangerColor = Config.instance.colors.danger
        
        return UpdateConfirmNewPINViewProps(navTitle: navTitle, title: titleText, showPinText: showPinText, hidePinText: hidePinText, primaryColor: primaryColor, accentColor: accentColor, dangerColor: dangerColor)
    }()
    
    init(_ viewController: UpdateConfirmNewPINViewComponent) {
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

class UpdateConfirmNewPINViewController: UIViewController {
    // Pass oldCode here
    public var oldCode: String?
    
    // Pass prevCode here by UpdateConfirmNewPINViewController.prevCode = code
    public var prevCode: String?
    
    @IBOutlet weak var pinVisibilityButton: UIButton!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var codeTextField: OneTimeCodeTextField!
    
    @IBOutlet weak var keyboardView: KeyboardView!

    lazy var presenter: UpdateConfirmNewPINViewPresenter = UpdateConfirmNewPINViewPresenterImpl(self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("loaded Update Confirm New PIN View!")
        
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
            if result != nil || self.findSequence(sequenceLength: code.count, in: code) {
                if self.errorLabel.isHidden {
                    self.toggleErrorMsg(msg: CotterStrings.instance.getText(for: PinErrorMessagesKey.badPin))
                }
                return false
            }
            
            // Define the callback
            func updateCb(response: CotterResult<CotterUser>) {
                LoadingScreen.shared.stop()
                switch response {
                case .success:
                    self.codeTextField.clear()
                    // Go to PIN Final View
                    let pinFinalVC = Cotter.cotterStoryboard.instantiateViewController(withIdentifier: "PINFinalViewController")as! PINFinalViewController
                     pinFinalVC.requireAuth = false
                    self.navigationController?.pushViewController(pinFinalVC, animated: true)
                    
                case .failure(let err):
                    // we can handle multiple error results here
                    print(err.localizedDescription)

                    // Display Error
                    if self.errorLabel.isHidden {
                        self.toggleErrorMsg(msg: CotterStrings.instance.getText(for: PinErrorMessagesKey.updatePinFailed))
                    }
                }
            }
            
            LoadingScreen.shared.start(at: self.view.window)
            // Run API to update PIN
            CotterAPIService.shared.updateUserPin(
                oldCode: self.oldCode!,
                newCode: code,
                cb: updateCb
            )
            
            return true
        }
    }
    
}

// MARK: - UpdateConfirmNewPINViewComponent Instantiations
extension UpdateConfirmNewPINViewController: UpdateConfirmNewPINViewComponent {
    func setupUI() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layoutIfNeeded()
        
        self.navigationItem.hidesBackButton = true
        let backButton = UIBarButtonItem(title: "\u{2190}", style: UIBarButtonItem.Style.plain, target: self, action: #selector(UpdateConfirmNewPINViewController.promptBack(sender:)))
        backButton.tintColor = UIColor.black
        self.navigationItem.leftBarButtonItems = [backButton]
        
        errorLabel.isHidden = true
        
        codeTextField.configure()
    }
    
    @objc private func promptBack(sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setupDelegates() {
        self.keyboardView.delegate = self
    }
    
    func render(_ props: UpdateConfirmNewPINViewProps) {
        setupLeftTitleBar(with: props.navTitle)
        titleLabel.text = props.title
        pinVisibilityButton.setTitle(props.showPinText, for: .normal)
        pinVisibilityButton.setTitleColor(props.primaryColor, for: .normal)
        errorLabel.textColor = props.dangerColor
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
extension UpdateConfirmNewPINViewController : KeyboardViewDelegate {
    func keyboardButtonTapped(buttonNumber: NSInteger) {
        if buttonNumber == -1 {
            codeTextField.removeNumber()
        } else {
            codeTextField.appendNumber(buttonNumber: buttonNumber)
        }
    }
}
