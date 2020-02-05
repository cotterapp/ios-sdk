//
//  AlertService.swift
//  CotterIOS
//
//  Created by Raymond Andrie on 2/3/20.
//

import Foundation

class AlertService {
    
    public func alert(
        title: String,
        body: String,
        actionButtonTitle: String,
        actionHandler: (() -> Void)? = nil,
        cancelButtonTitle: String,
        cancelHandler: (() -> Void)? = nil
    ) -> AlertViewController {
        let storyboard = UIStoryboard(name: "AlertStoryboard", bundle: Bundle(identifier: "org.cocoapods.CotterIOS"))
        let alertVC = storyboard.instantiateViewController(withIdentifier: "AlertVC") as! AlertViewController
        
        alertVC.initialize(
            title: title,
            body: body,
            actionTitle: actionButtonTitle,
            actionHandler: actionHandler,
            cancelTitle: cancelButtonTitle,
            cancelHandler: cancelHandler
        )
        
        return alertVC
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
        let storyboard = UIStoryboard(name: "AlertStoryboard", bundle: Bundle(identifier: "org.cocoapods.CotterIOS"))
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
    public func createDefaultAlert(
        title: String,
        body: String,
        actionText: String,
        cancelText: String,
        actionHandler: (() -> Void)? = nil,
        cancelHandler: (() -> Void)? = nil
    ) -> UIAlertController {
        let alert = UIAlertController(title: title, message: body, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: cancelText, style: UIAlertAction.Style.default, handler: { (action) in
            alert.dismiss(animated: true, completion: cancelHandler)
        }))
        
        alert.addAction(UIAlertAction(title: actionText, style: UIAlertAction.Style.default, handler: { (action) in
            alert.dismiss(animated: true, completion: actionHandler)
        }))
        
        return alert
    }

}
