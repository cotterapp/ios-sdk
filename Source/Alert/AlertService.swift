//
//  AlertService.swift
//  CotterIOS
//
//  Created by Raymond Andrie on 2/3/20.
//

import Foundation

@objc protocol AlertServiceDelegate : class {
    @objc func cancelHandler()
    @objc func actionHandler()
}

class AlertService: NSObject {
    var delegate: AlertServiceDelegate?
  
    // Components
    let darkOverlayView = UIView()
    let alertView = UIView()
    let titleLabel = UILabel()
    let bodyLabel = UILabel()
    let cancelButton = UIButton()
    let actionButton = UIButton()
    let imageView = UIImageView()
  
    public init(
        vc: UIViewController,
        title: String,
        body: String,
        actionButtonTitle: String,
        cancelButtonTitle: String,
        imagePath: String? = nil
    ) {
        guard let nc = vc.navigationController else { return }
        
        // Dark overlay right below the alert view, covering the whole current UIViewController vc
        darkOverlayView.frame = CGRect(x: 0.0, y: 0.0, width: nc.view.frame.width, height: nc.view.frame.height)
        darkOverlayView.backgroundColor = UIColor.black
        darkOverlayView.alpha = 0.0
        nc.view.addSubview(darkOverlayView)
        
        let outerHorizontalOffset: CGFloat = 50.0
        let outerVerticalOffset: CGFloat = nc.view.frame.height * 0.7
        let innerHorizontalOffset: CGFloat = 40.0
        let innerVerticalOffset: CGFloat = 60.0
        
        // The actual alert view
        let width: CGFloat = nc.view.frame.width - outerHorizontalOffset
        let height: CGFloat = nc.view.frame.height - outerVerticalOffset
        let x: CGFloat = outerHorizontalOffset / 2
        let y: CGFloat = outerVerticalOffset / 2
        
        alertView.frame = CGRect(x: x, y: y, width: width, height: height)
        alertView.backgroundColor = UIColor.white
        alertView.layer.cornerRadius = 10
        
        titleLabel.frame = CGRect(x: innerHorizontalOffset / 2, y: innerVerticalOffset / 2, width: width - innerHorizontalOffset, height: height - innerVerticalOffset)
        titleLabel.text = title
        titleLabel.textColor = UIColor.systemGreen
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20.0)
        titleLabel.numberOfLines = 1
        titleLabel.sizeToFit()
        alertView.addSubview(titleLabel)
        
        bodyLabel.frame = CGRect(x: innerHorizontalOffset / 2, y: innerVerticalOffset / 2 + 50.0, width: width - innerHorizontalOffset, height: height - innerVerticalOffset)
        bodyLabel.text = body
        bodyLabel.textColor = UIColor.darkGray
        bodyLabel.font = UIFont.systemFont(ofSize: 17.0)
        bodyLabel.numberOfLines = 0
        bodyLabel.sizeToFit()
        alertView.addSubview(bodyLabel)
        
        cancelButton.frame = CGRect(x: 86.0, y: 186.0, width: 80.0, height: 30.0)
        cancelButton.setTitle(cancelButtonTitle, for: .normal)
        cancelButton.setTitleColor(UIColor.systemGreen, for: .normal)
        alertView.addSubview(cancelButton)
        
        actionButton.frame = CGRect(x: 178.0, y: 186.0, width: 80.0, height: 30.0)
        actionButton.setTitle(actionButtonTitle, for: .normal)
        actionButton.setTitleColor(UIColor.systemGreen, for: .normal)
        alertView.addSubview(actionButton)
      
        if let path = imagePath {
            let imageSize = nc.view.frame.width * 0.2
            imageView.frame = CGRect(x: innerHorizontalOffset / 2, y: innerVerticalOffset / 2 + 50.0, width: imageSize, height: imageSize)
            imageView.download(from: path)
            alertView.addSubview(imageView)
          
            bodyLabel.frame = CGRect(x: innerHorizontalOffset + imageSize, y: innerVerticalOffset / 2 + 50.0, width: width - imageSize - innerHorizontalOffset * 1.5, height: height - innerVerticalOffset)
            bodyLabel.sizeToFit()
        }

        alertView.alpha = 0.0
        nc.view.addSubview(alertView)
    }
    
    public func show(from vc: UIViewController) {
        // Bind cancel & action handlers
        let tapRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: vc, action: #selector(delegate?.cancelHandler))
        darkOverlayView.addGestureRecognizer(tapRecognizer)
        cancelButton.addTarget(vc, action: #selector(delegate?.cancelHandler), for: .touchUpInside)
        actionButton.addTarget(vc, action: #selector(delegate?.actionHandler), for: .touchUpInside)
      
        UIView.animate(
            withDuration: 0.2,
            delay: 0.0,
            options: .curveEaseIn,
            animations: { () -> Void in
                self.darkOverlayView.alpha = 0.6
                self.alertView.alpha = 1.0
            },
            completion: nil
        )
    }
    
    public func hide() {
        UIView.animate(
            withDuration: 0.2,
            delay: 0.0,
            options: .curveEaseIn,
            animations: { () -> Void in
                self.darkOverlayView.alpha = 0.0
                self.alertView.alpha = 0.0
            },
            completion: nil
        )
    }
    
    public func alertWithImage(
        title: String,
        body: String,
        imagePath: String?,
        actionButtonTitle: String,
        actionHandler: (() -> Void)? = nil,
        cancelButtonTitle: String,
        cancelHandler: (() -> Void)? = nil
    ) -> AlertWithImageViewController {
        let storyboard = UIStoryboard(name: "AlertStoryboard", bundle: Bundle(identifier: "org.cocoapods.Cotter"))
        let alertWithImgVC = storyboard.instantiateViewController(withIdentifier: "AlertImgVC") as! AlertWithImageViewController
        
        alertWithImgVC.initialize(
            title: title,
            body: body,
            imagePath: imagePath,
            cancelTitle: cancelButtonTitle,
            actionTitle: actionButtonTitle
        )
        
        return alertWithImgVC
    }
    
    // Default Alert Function
    public static func createDefaultAlert(
        title: String,
        body: String,
        actionText: String,
        cancelText: String,
        actionHandler: (() -> Void)? = nil,
        cancelHandler: (() -> Void)? = nil
    ) -> UIAlertController {
        let alert = UIAlertController(title: title, message: body, preferredStyle: UIAlertController.Style.alert)
        
        // Cancel
        alert.addAction(UIAlertAction(title: cancelText, style: UIAlertAction.Style.default, handler: { (action) in
            alert.dismiss(animated: true, completion: cancelHandler)
        }))
        
        // Action
        alert.addAction(UIAlertAction(title: actionText, style: UIAlertAction.Style.default, handler: { (action) in
            alert.dismiss(animated: true, completion: actionHandler)
        }))
        
        return alert
    }

}
