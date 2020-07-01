//
//  BottomPopupModal.swift
//  Cotter
//
//  Created by Albert Purnama on 3/26/20.
//

import UIKit

class BottomPopupModal {
    let parentVC: UIViewController
    let img: UIImage
    let title: String
    let body: String
    
    
    let darkOverlayView = UIView()
    let promptView = UIView()
    let promptBody = UIView()
    let titleLabel = UILabel()
    let bodyLabel = UILabel()
    let imageView = UIImageView()
    
    public init(
        vc: UIViewController,
        img: UIImage,
        title: String,
        body: String
    ) {
        self.parentVC = vc
        self.img = img
        self.title = title
        self.body = body
        
        self.initView()
    }
    
    private func initView() {
        guard let nc = self.parentVC.navigationController, let nv = nc.view else { return }
        
        // Dark overlay right below the alert view, covering the whole current UIViewController vc
        darkOverlayView.backgroundColor = UIColor.black
        darkOverlayView.alpha = 0.6
        darkOverlayView.translatesAutoresizingMaskIntoConstraints = false
        nv.addSubview(darkOverlayView)

        // The actual alert view
        promptView.backgroundColor = UIColor.white
        promptView.layer.cornerRadius = 10
        promptView.alpha = 1.0
        promptView.translatesAutoresizingMaskIntoConstraints = false
        // TODO: add animations
        nv.addSubview(promptView)

        promptBody.translatesAutoresizingMaskIntoConstraints = false
        promptView.addSubview(promptBody)
        
        titleLabel.text = self.title
        titleLabel.textColor = UIColor.black
        titleLabel.font = UIFont.boldSystemFont(ofSize: 21.0)
        titleLabel.numberOfLines = 0
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        promptBody.addSubview(titleLabel)
        
        bodyLabel.text = self.body
        bodyLabel.textColor = UIColor.darkGray
        bodyLabel.font = UIFont.systemFont(ofSize: 15.0)
        bodyLabel.numberOfLines = 0
        bodyLabel.translatesAutoresizingMaskIntoConstraints = false
        promptBody.addSubview(bodyLabel)

        let imageSize = nv.frame.height * 0.15
        imageView.image = self.img
        imageView.translatesAutoresizingMaskIntoConstraints = false
        promptBody.addSubview(imageView)
        
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
            imageView.heightAnchor.constraint(equalToConstant: imageSize)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    public func dismiss(animated:Bool = true) {
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
    }
}
