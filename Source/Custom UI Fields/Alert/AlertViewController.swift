//
//  AlertViewController.swift
//  CotterIOS
//
//  Created by Raymond Andrie on 2/3/20.
//

import Foundation

class AlertViewController : UIViewController {
    
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
    
    @IBOutlet weak var actionButton: UIButton!
    
    @IBOutlet weak var cancelButton: UIButton!
    
    public func initialize(
        title: String,
        body: String,
        actionTitle: String,
        actionHandler: (() -> Void)? = nil,
        cancelTitle: String,
        cancelHandler: (() -> Void)? = nil
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
        actionButton.setTitle(actionButtonTitle, for: .normal)
        cancelButton.setTitle(cancelButtonTitle, for: .normal)
        
        // Styling
        alertView.layer.cornerRadius = 5
        alertView.layer.masksToBounds = true
    }
    
    @IBAction func didTapCancel(_ sender: Any) {
        if cancelButtonHandler != nil {
            dismiss(animated: true)
            cancelButtonHandler!()
        } else {
            dismiss(animated: true)
        }
    }
    
    @IBAction func didTapAction(_ sender: Any) {
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
