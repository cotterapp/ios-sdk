//
//  BottomPopupModal.swift
//  Cotter
//
//  Created by Albert Purnama on 3/26/20.
//

import UIKit
import os.log

@objc protocol BottomPopupModalDelegate {
    func dismissCompletion()
    @objc func actionHandler()
    @objc func cancelHandler()
}

class PromptView: UIView {
    override func layoutSubviews() {
        super.layoutSubviews()
        roundCorners(corners: [.topLeft, .topRight], radius: 15.0)
    }
}

class BottomPopupModal {
    var delegate: BottomPopupModalDelegate? = nil
    let img: UIImage
    let title: String
    let body: String
    let cancelText: String?
    let actionText: String?
    
    let darkOverlayView = UIView()
    let promptView = PromptView()
    let promptBody = UIView()
    let titleLabel = UILabel()
    let bodyLabel = UILabel()
    let imageView = UIImageView()
    let actionButton = UIButton()
    let cancelButton = UIButton()
    
    public init(
        img: UIImage,
        title: String,
        body: String,
        actionText: String? = nil,
        cancelText: String? = nil
    ) {
        self.img = img
        self.title = title
        self.body = body
        self.actionText = actionText
        self.cancelText = cancelText
    }
    
    public func show() {
        guard let nv = UIWindow.key else {
            return
            
        }
        
        let fonts = Config.instance.fonts

        // Dark overlay right below the alert view, covering the whole current UIViewController vc
        darkOverlayView.backgroundColor = UIColor.black
        darkOverlayView.alpha = 0.6
        darkOverlayView.translatesAutoresizingMaskIntoConstraints = false
        let tapRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismiss))
        darkOverlayView.addGestureRecognizer(tapRecognizer)
        
        nv.addSubview(darkOverlayView)

        // The actual alert view
        promptView.backgroundColor = UIColor.white
        promptView.alpha = 1.0
        promptView.translatesAutoresizingMaskIntoConstraints = false
        // TODO: add animations
        nv.addSubview(promptView)

        promptBody.translatesAutoresizingMaskIntoConstraints = false
        promptView.addSubview(promptBody)
        
        titleLabel.text = self.title
        titleLabel.textColor = UIColor.black
        titleLabel.font = fonts.heading
        titleLabel.numberOfLines = 0
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        promptBody.addSubview(titleLabel)
        
        bodyLabel.text = self.body
        bodyLabel.textColor = UIColor.darkGray
        bodyLabel.font = fonts.title
        bodyLabel.numberOfLines = 0
        bodyLabel.translatesAutoresizingMaskIntoConstraints = false
        promptBody.addSubview(bodyLabel)

        let imageSize = nv.frame.height * 0.15
        imageView.image = self.img
        imageView.translatesAutoresizingMaskIntoConstraints = false
        promptBody.addSubview(imageView)
        
        actionButton.setTitle(self.actionText, for: .normal)
        actionButton.setTitleColor(Config.instance.colors.primary, for: .normal)
        actionButton.titleLabel?.font = fonts.subtitle
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        actionButton.addTarget(delegate, action: #selector(delegate?.actionHandler), for: .touchUpInside)
        promptBody.addSubview(actionButton)
        
        cancelButton.setTitle(self.cancelText, for: .normal)
        cancelButton.titleLabel?.font = fonts.subtitle
        cancelButton.setTitleColor(Config.instance.colors.primary, for: .normal)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.addTarget(delegate, action: #selector(delegate?.cancelHandler), for: .touchUpInside)
        promptBody.addSubview(cancelButton)
        
        let innerLeftConstraint: CGFloat = 30.0
        let innerRightConstraint: CGFloat = -1 * innerLeftConstraint
        
        let constraints = [
            darkOverlayView.centerXAnchor.constraint(equalTo: nv.centerXAnchor),
            darkOverlayView.centerYAnchor.constraint(equalTo: nv.centerYAnchor),
            darkOverlayView.widthAnchor.constraint(equalTo: nv.widthAnchor),
            darkOverlayView.heightAnchor.constraint(equalTo: nv.heightAnchor),
            promptView.centerXAnchor.constraint(equalTo: nv.centerXAnchor),
            promptView.bottomAnchor.constraint(equalTo: nv.bottomAnchor),
            promptView.widthAnchor.constraint(equalTo: nv.widthAnchor),
            promptView.heightAnchor.constraint(equalTo: nv.heightAnchor, multiplier: CGFloat(0.40)),
            promptBody.topAnchor.constraint(equalTo: promptView.topAnchor),
            promptBody.leftAnchor.constraint(equalTo: promptView.leftAnchor, constant: innerLeftConstraint),
            promptBody.rightAnchor.constraint(equalTo: promptView.rightAnchor, constant: innerRightConstraint),
            promptBody.bottomAnchor.constraint(equalTo: nv.layoutMarginsGuide.bottomAnchor),
            titleLabel.topAnchor.constraint(equalTo: promptBody.topAnchor, constant: CGFloat(30.0)),
            titleLabel.leftAnchor.constraint(equalTo: promptBody.leftAnchor),
            titleLabel.rightAnchor.constraint(equalTo: promptBody.rightAnchor),
            bodyLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: CGFloat(20)),
            bodyLabel.leftAnchor.constraint(equalTo: promptBody.leftAnchor),
            bodyLabel.rightAnchor.constraint(equalTo: promptBody.rightAnchor),
            imageView.centerXAnchor.constraint(equalTo: promptBody.centerXAnchor),
            imageView.bottomAnchor.constraint(equalTo: nv.layoutMarginsGuide.bottomAnchor, constant: CGFloat(-40)),
            imageView.widthAnchor.constraint(equalToConstant: imageSize),
            imageView.heightAnchor.constraint(equalToConstant: imageSize),
            cancelButton.leftAnchor.constraint(equalTo: promptBody.leftAnchor),
            cancelButton.bottomAnchor.constraint(equalTo: promptBody.bottomAnchor),
            actionButton.rightAnchor.constraint(equalTo: promptBody.rightAnchor),
            actionButton.bottomAnchor.constraint(equalTo: promptBody.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    @objc public func dismiss(animated:Bool = true) {
        if animated {
            // add some nice animation
            UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseIn],
                           animations: {
                            self.promptView.center.y += self.promptView.bounds.height
                            self.promptView.layoutIfNeeded()
            }, completion: { complete in
                self.promptView.removeFromSuperview()
                self.darkOverlayView.removeFromSuperview()
            })
        } else {
            self.promptView.removeFromSuperview()
            self.darkOverlayView.removeFromSuperview()
        }
        
        delegate?.dismissCompletion()
    }
}
