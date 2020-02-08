//
//  UIExtensions.swift
//  CotterIOS
//
//  Created by Raymond Andrie on 2/7/20.
//

import Foundation

// The following extension is copied from https://stackoverflow.com/questions/43107798/set-shadow-on-bottom-uiview-only
extension UIView {
    func dropShadow() {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.25
        layer.shadowOffset = CGSize(width: 0, height: -1)
        layer.shadowRadius = 1
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }
}

// The following extensions is inspired by https://gist.github.com/Isuru-Nanayakkara/496d5713e61125bddcf5

public enum UIButtonBorderSide {
    case Top, Bottom, Left, Right
}

extension UIButton {
    
    public func addFullBorder(side: UIButtonBorderSide, borderColor: UIColor, borderWidth: CGFloat) {
        let border = CALayer()
        border.backgroundColor = borderColor.cgColor
        
        switch side {
        case .Top:
            border.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: borderWidth)
        case .Bottom:
            border.frame = CGRect(x: 0, y: frame.size.height - borderWidth, width: frame.size.width, height: borderWidth)
        case .Left:
            border.frame = CGRect(x: 0, y: 0, width: borderWidth, height: frame.size.height)
        case .Right:
            border.frame = CGRect(x: frame.size.width - borderWidth, y: 0, width: borderWidth, height: frame.size.height)
        }
        
        self.layer.addSublayer(border)
    }
    
    public func addTwoThirdsBorder(side: UIButtonBorderSide, borderColor: UIColor, borderWidth: CGFloat) {
        let border = CALayer()
        border.backgroundColor = borderColor.cgColor
        
        let horizontalStart = frame.size.width / 6.0
        let horizontalLength = (2.0 / 3.0) * frame.size.width
        
        let verticalStart = frame.size.height / 3.0
        let verticalLength = frame.size.height - verticalStart
        
        switch side {
        case .Top:
            border.frame = CGRect(x: horizontalStart, y: 0, width: horizontalLength, height: borderWidth)
        case .Bottom:
            border.frame = CGRect(x: horizontalStart, y: frame.size.height - borderWidth, width: horizontalLength, height: borderWidth)
        case .Left:
            border.frame = CGRect(x: 0, y: verticalStart, width: borderWidth, height: verticalLength)
        case .Right:
            border.frame = CGRect(x: frame.size.width - borderWidth, y: verticalStart, width: borderWidth, height: verticalLength)
        }
        self.layer.addSublayer(border)
    }
    
    public func addGroundNumsTwoThirdsBorder(side: UIButtonBorderSide, borderColor: UIColor, borderWidth: CGFloat) {
        let border = CALayer()
        border.backgroundColor = borderColor.cgColor
        
        let horizontalStart = frame.size.width / 6.0
        let horizontalLength = (2.0 / 3.0) * frame.size.width
        
        let verticalLength = (2.0 / 3.0) * frame.size.height
        
        switch side {
        case .Top:
            border.frame = CGRect(x: horizontalStart, y: 0, width: horizontalLength, height: borderWidth)
        case .Bottom:
            border.frame = CGRect(x: horizontalStart, y: frame.size.height - borderWidth, width: horizontalLength, height: borderWidth)
        case .Left:
            border.frame = CGRect(x: 0, y: 0, width: borderWidth, height: verticalLength)
        case .Right:
            border.frame = CGRect(x: frame.size.width - borderWidth, y: 0, width: borderWidth, height: verticalLength)
        }
        self.layer.addSublayer(border)
    }
}

extension UILabel {
    
    public func addFullBorder(side: UIButtonBorderSide, borderColor: UIColor, borderWidth: CGFloat) {
        let border = CALayer()
        border.backgroundColor = borderColor.cgColor
        
        switch side {
        case .Top:
            border.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: borderWidth)
        case .Bottom:
            border.frame = CGRect(x: 0, y: frame.size.height - borderWidth, width: frame.size.width, height: borderWidth)
        case .Left:
            border.frame = CGRect(x: 0, y: 0, width: borderWidth, height: frame.size.height)
        case .Right:
            border.frame = CGRect(x: frame.size.width - borderWidth, y: 0, width: borderWidth, height: frame.size.height)
        }
        
        self.layer.addSublayer(border)
    }
    
    public func addTwoThirdsBorder(side: UIButtonBorderSide, borderColor: UIColor, borderWidth: CGFloat) {
        let border = CALayer()
        border.backgroundColor = borderColor.cgColor
        
        let horizontalStart = frame.size.width / 6.0
        let horizontalLength = (2.0 / 3.0) * frame.size.width
        
        let verticalStart = frame.size.height / 3.0
        let verticalLength = frame.size.height - verticalStart
        
        switch side {
        case .Top:
            border.frame = CGRect(x: horizontalStart, y: 0, width: horizontalLength, height: borderWidth)
        case .Bottom:
            border.frame = CGRect(x: horizontalStart, y: frame.size.height - borderWidth, width: horizontalLength, height: borderWidth)
        case .Left:
            border.frame = CGRect(x: 0, y: verticalStart, width: borderWidth, height: verticalLength)
        case .Right:
            border.frame = CGRect(x: frame.size.width - borderWidth, y: verticalStart, width: borderWidth, height: verticalLength)
        }
        self.layer.addSublayer(border)
    }
    
    public func addGroundNumsTwoThirdsBorder(side: UIButtonBorderSide, borderColor: UIColor, borderWidth: CGFloat) {
        let border = CALayer()
        border.backgroundColor = borderColor.cgColor
        
        let horizontalStart = frame.size.width / 6.0
        let horizontalLength = (2.0 / 3.0) * frame.size.width
        
        let verticalLength = (2.0 / 3.0) * frame.size.height
        
        switch side {
        case .Top:
            border.frame = CGRect(x: horizontalStart, y: 0, width: horizontalLength, height: borderWidth)
        case .Bottom:
            border.frame = CGRect(x: horizontalStart, y: frame.size.height - borderWidth, width: horizontalLength, height: borderWidth)
        case .Left:
            border.frame = CGRect(x: 0, y: 0, width: borderWidth, height: verticalLength)
        case .Right:
            border.frame = CGRect(x: frame.size.width - borderWidth, y: 0, width: borderWidth, height: verticalLength)
        }
        self.layer.addSublayer(border)
    }
}
