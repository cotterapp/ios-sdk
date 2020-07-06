//
//  AlertService.swift
//  CotterIOS
//
//  Created by Raymond Andrie on 2/3/20.
//

import Foundation
import UIKit

@objc protocol AlertServiceDelegate : class {
    @objc func cancelHandler()
    @objc func actionHandler()
}

class AlertService: NSObject {
    var delegate: AlertServiceDelegate?
    var parentVC: UIViewController!
  
    // Components
    let darkOverlayView = UIView()
    let alertView = UIView()
    let titleLabel = UILabel()
    let bodyLabel = UILabel()
    let cancelButton = UIButton()
    let actionButton = UIButton()
    let imageView = UIImageView()
    
    let bodyStackView = UIStackView()
  
    public init(
        vc: UIViewController,
        title: String,
        body: String,
        actionButtonTitle: String,
        cancelButtonTitle: String,
        imagePath: String? = nil
    ) {
        guard let nc = vc.navigationController, let nv = nc.view else { return }
      
        parentVC = vc
        
        // Dark overlay right below the alert view, covering the whole current UIViewController vc
        darkOverlayView.backgroundColor = UIColor.black
        darkOverlayView.alpha = 0.0
        darkOverlayView.translatesAutoresizingMaskIntoConstraints = false
        nv.addSubview(darkOverlayView)
        
        // The actual alert view
        alertView.backgroundColor = UIColor.white
        alertView.layer.cornerRadius = 10
        alertView.alpha = 0.0
        alertView.translatesAutoresizingMaskIntoConstraints = false
        nv.addSubview(alertView)
        
        titleLabel.text = title
        titleLabel.textColor = UIColor.black
        titleLabel.font = Config.instance.fonts.title
        titleLabel.numberOfLines = 0
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        alertView.addSubview(titleLabel)
        
        bodyLabel.text = body
        bodyLabel.textColor = UIColor.darkGray
        bodyLabel.font = Config.instance.fonts.paragraph
        bodyLabel.numberOfLines = 0
        bodyLabel.translatesAutoresizingMaskIntoConstraints = false
        
        cancelButton.setTitle(cancelButtonTitle, for: .normal)
        cancelButton.setTitleColor(Config.instance.colors.primary, for: .normal)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.titleLabel?.font = Config.instance.fonts.subtitle
        alertView.addSubview(cancelButton)
        
        actionButton.setTitle(actionButtonTitle, for: .normal)
        actionButton.setTitleColor(Config.instance.colors.primary, for: .normal)
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        actionButton.titleLabel?.font = Config.instance.fonts.subtitle
        alertView.addSubview(actionButton)
      
        var imageSize: CGFloat = 0.0
        if let path = imagePath {
            imageSize = nc.view.frame.width * 0.15
            
            let cotterImages = ImageObject.defaultImages
            if cotterImages.contains(path) {
                imageView.image = UIImage(named: path, in: Cotter.resourceBundle, compatibleWith: nil)
                
            } else {
                imageView.image = UIImage(named: path, in: Bundle.main, compatibleWith: nil)
            }
        }
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        // using stackview
        bodyStackView.axis = .horizontal
        bodyStackView.alignment = .center
        
        bodyStackView.addArrangedSubview(imageView)
        bodyStackView.addArrangedSubview(bodyLabel)
        bodyStackView.translatesAutoresizingMaskIntoConstraints = false
        alertView.addSubview(bodyStackView)
      
        let innerLeftConstraint: CGFloat = 20.0
        let innerRightConstraint: CGFloat = -1 * innerLeftConstraint
      
        let constraints = [
            // Alert box constraints
            darkOverlayView.centerXAnchor.constraint(equalTo: nv.centerXAnchor),
            darkOverlayView.centerYAnchor.constraint(equalTo: nv.centerYAnchor),
            darkOverlayView.widthAnchor.constraint(equalTo: nv.widthAnchor),
            darkOverlayView.heightAnchor.constraint(equalTo: nv.heightAnchor),
            alertView.centerXAnchor.constraint(equalTo: nv.centerXAnchor),
            alertView.centerYAnchor.constraint(equalTo: nv.centerYAnchor),
            alertView.widthAnchor.constraint(equalTo: nv.widthAnchor, constant: -80.0),
            
            // Title constraints
            titleLabel.topAnchor.constraint(equalTo: alertView.topAnchor, constant: 20.0),
            titleLabel.leftAnchor.constraint(equalTo: alertView.leftAnchor, constant: innerLeftConstraint),
            titleLabel.rightAnchor.constraint(equalTo: alertView.rightAnchor, constant: innerRightConstraint),
            
            // Body constraints
            bodyStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20.0),
            bodyStackView.leftAnchor.constraint(equalTo: alertView.leftAnchor, constant: innerLeftConstraint),
            bodyStackView.rightAnchor.constraint(equalTo: alertView.rightAnchor, constant: innerRightConstraint),
            imageView.widthAnchor.constraint(equalToConstant: imageSize),
            imageView.heightAnchor.constraint(equalToConstant: imageSize),
            bodyLabel.topAnchor.constraint(equalTo: bodyStackView.topAnchor),
            bodyLabel.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: imageSize > 0.0 ? 20.0 : 0.0),
            bodyLabel.rightAnchor.constraint(equalTo: bodyStackView.rightAnchor),
            
            // Buttons constraints
            cancelButton.topAnchor.constraint(equalTo: bodyStackView.bottomAnchor, constant: 40.0),
            cancelButton.rightAnchor.constraint(equalTo: alertView.rightAnchor, constant: innerRightConstraint),
            actionButton.topAnchor.constraint(equalTo: bodyStackView.bottomAnchor, constant: 40.0),
            actionButton.rightAnchor.constraint(equalTo: cancelButton.leftAnchor, constant: innerRightConstraint - 10.0),
            alertView.bottomAnchor.constraint(equalTo: cancelButton.bottomAnchor, constant: 20.0),
        ]
      
        NSLayoutConstraint.activate(constraints)
    }
    
  public func show(onComplete: ((Bool) -> Void)? = nil) {
        // Bind cancel & action handlers
        let tapRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: delegate, action: #selector(delegate?.cancelHandler))
        darkOverlayView.addGestureRecognizer(tapRecognizer)
        cancelButton.addTarget(delegate, action: #selector(delegate?.cancelHandler), for: .touchUpInside)
        actionButton.addTarget(delegate, action: #selector(delegate?.actionHandler), for: .touchUpInside)
    
        UIView.animate(
            withDuration: 0.2,
            delay: 0.0,
            options: .curveEaseIn,
            animations: { () -> Void in
                self.darkOverlayView.alpha = 0.6
                self.alertView.alpha = 1.0
            },
            completion: onComplete
        )
    }
    
    public func hide(onComplete: ((Bool) -> Void)? = nil) {
        UIView.animate(
            withDuration: 0.2,
            delay: 0.0,
            options: .curveEaseIn,
            animations: { () -> Void in
                self.darkOverlayView.alpha = 0.0
                self.alertView.alpha = 0.0
            },
            completion: onComplete
        )
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
