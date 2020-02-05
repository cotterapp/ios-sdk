//
//  AlertWithImageViewController.swift
//  CotterIOS
//
//  Created by Raymond Andrie on 2/4/20.
//

import Foundation

class AlertWithImageViewController : UIViewController {
    
    private var myTitle = String()

    private var myBody = String()

    private var actionButtonTitle = String()

    private var cancelButtonTitle = String()

    private var cancelButtonHandler: (() -> Void)?

    private var actionButtonHandler: (() -> Void)?
    
    @IBOutlet weak var alertView: UIView!
    
    @IBOutlet weak var alertTitle: UILabel!
    
    @IBOutlet weak var alertImage: UIImageView!
    
    @IBOutlet weak var alertBody: UILabel!
    
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var actionButton: UIButton!
    
    public func initialize(
        title: String,
        body: String,
        imagePath: String?,
        cancelTitle: String,
        cancelHandler: (() -> Void)? = nil,
        actionTitle: String,
        actionHandler: (() -> Void)? = nil
    ) {
        myTitle = title
        myBody = body
        actionButtonTitle = actionTitle
        cancelButtonTitle = cancelTitle
        actionButtonHandler = actionHandler
        cancelButtonHandler = cancelHandler

    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    func setupView() {
        alertTitle.text = myTitle
        alertBody.text = myBody
        alertBody.numberOfLines = 0
        alertBody.sizeToFit()
        actionButton.setTitle(actionButtonTitle, for: .normal)
        cancelButton.setTitle(cancelButtonTitle, for: .normal)
        
        // Styling
        alertView.layer.cornerRadius = 5
        alertView.layer.masksToBounds = true
    }
    
    
    @IBAction func onTapCancel(_ sender: Any) {
        if cancelButtonHandler != nil {
            dismiss(animated: true)
            cancelButtonHandler!()
        } else {
            dismiss(animated: true)
        }
    }
    
    @IBAction func onTapAction(_ sender: Any) {
        if actionButtonHandler != nil {
            dismiss(animated: true)
            actionButtonHandler!()
        } else {
            dismiss(animated: true)
        }
    }
    
    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
