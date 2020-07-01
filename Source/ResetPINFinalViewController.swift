//
//  ResetPINFinalViewController.swift
//  Cotter
//
//  Created by Raymond Andrie on 3/22/20.
//

import UIKit

// MARK: - Keys for Strings
public class ResetPINFinalViewControllerKey {
    static let title = "ResetPINFinalViewController/title"
}

// MARK: - Presenter Protocol delegated UI-related logic
protocol ResetPINFinalViewPresenter {
    func onViewLoaded()
}

// MARK: - Properties of ResetPINFinalViewController
struct ResetPINFinalViewProps {
    let successTitle: String
    let successImage: String
}

// MARK: - Components of ResetPINFinalViewController
protocol ResetPINFinalViewComponent: AnyObject {
    func setupUI()
    func render(_ props: ResetPINFinalViewProps)
}

// MARK: - ResetPINFinalViewPresenter Implementation
class ResetPINFinalViewPresenterImpl: ResetPINFinalViewPresenter {
    
    typealias VCTextKey = ResetPINFinalViewControllerKey
    
    weak var viewController: ResetPINFinalViewComponent!
    
    let props: ResetPINFinalViewProps = {
        // MARK: VC Text Definitions
        let successTitle = CotterStrings.instance.getText(for: VCTextKey.title)
        
        // MARK: - VC Image Definitions
        let successImage = CotterImages.instance.getImage(for: VCImageKey.resetPinSuccessImg)
        
        return ResetPINFinalViewProps(successTitle: successTitle, successImage: successImage)
    }()
    
    init(_ viewController: ResetPINFinalViewComponent) {
        self.viewController = viewController
    }
    
    func onViewLoaded() {
        viewController.setupUI()
        viewController.render(props)
    }
    
}

class ResetPINFinalViewController: UIViewController {
    
    typealias VCTextKey = ResetPINFinalViewControllerKey
    
    var imagePath: String? = nil
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var successLabel: UILabel!
    
    lazy var presenter: ResetPINFinalViewPresenter = ResetPINFinalViewPresenterImpl(self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("loaded Reset PIN Final View!")
        
        // Add Set-up here
        presenter.onViewLoaded()
        
        endFlow()
    }
}

// MARK: - ResetPINFinalViewComponent Instantiations
extension ResetPINFinalViewController: ResetPINFinalViewComponent {
    func setupUI() {
        self.navigationItem.hidesBackButton = true
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layoutIfNeeded()
    }
    
    func render(_ props: ResetPINFinalViewProps) {
        successLabel.text = props.successTitle
        successLabel.font = Config.instance.fonts.paragraph
        
        let cotterImages = ImageObject.defaultImages
        if cotterImages.contains(props.successImage) {
            print("[ResetPINFinalViewController] Using Default Image...")
            imageView.image = UIImage(named: props.successImage, in: Cotter.resourceBundle, compatibleWith: nil)
        } else { // User configured their own image
            imageView.image = UIImage(named: props.successImage, in: Bundle.main, compatibleWith: nil)
        }
        imagePath = props.successImage
    }

}

// MARK: - Private Helper Functions
extension ResetPINFinalViewController {
    private func endFlow() {
        // Dismiss VC after 3 seconds, then run callback
        let timer = DispatchTime.now() + 3
        DispatchQueue.main.asyncAfter(deadline: timer) {
            let cbFunc = Config.instance.transactionCb
            cbFunc("Token from Transaction PIN View after resetting PIN!", nil)
            return
        }
    }
}
