//
//  UIExtensions.swift
//  CotterIOS
//
//  Created by Raymond Andrie on 2/7/20.
//

import Foundation

// Finding a code sequence that is invalid
extension UIViewController {
    func findSequence(sequenceLength: Int, in string: String) -> Bool {
        // It would be better to extract this out of func
        let digits = CharacterSet.decimalDigits
        let controlSet = digits
        // ---

        let scalars = string.unicodeScalars
        let unicodeArray = scalars.map({ $0 })

        var i = 0

        var increasingLength = 1
        var decreasingLength = 1
        for number in unicodeArray where controlSet.contains(number) {
            if i+1 >= unicodeArray.count {
                break
            }
            let nextNumber = unicodeArray[i+1]
            
            if UnicodeScalar(number.value-1) == nextNumber {
                decreasingLength += 1
            }

            if UnicodeScalar(number.value+1) == nextNumber {
                increasingLength += 1
            }
            
            if decreasingLength >= sequenceLength || increasingLength >= sequenceLength {
                return true
            }
            i += 1
        }
        return false
    }
}

// The following extension is copied from https://stackoverflow.com/questions/43107798/set-shadow-on-bottom-uiview-only
extension UIView {
    func dropShadow() {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.25
        layer.shadowOffset = CGSize(width: 0, height: -1)
        layer.shadowRadius = 1
        layer.shadowPath = UIBezierPath(rect: CGRect(x: 0,
                                                     y: bounds.maxY - layer.shadowRadius,
                                                     width: UIScreen.main.bounds.width,
                                                     height: layer.shadowRadius)).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }
}

// The following extensions is inspired by https://gist.github.com/Isuru-Nanayakkara/496d5713e61125bddcf5

public enum UIButtonBorderSide {
    case Top, Bottom, Left, Right
}

public func getBorderDiff() -> CGFloat {
    let screenWidth = UIScreen.main.bounds.width
    
    if screenWidth <= 320.0 {
        // iPhone SE
        return CGFloat(32.0)
    } else if screenWidth <= 375.0 {
        // iPhone 8, iPhone X, etc.
        return CGFloat(15.0)
    } else if screenWidth <= 414 {
        // for iPhones
        return CGFloat(0)
    } else if screenWidth <= 768 {
        // for iPad Air 2, iPad Mini 4, etc
        return CGFloat(-110.0)
    } else if screenWidth <= 834 {
        // iPad pro 10.5
        return CGFloat(-150.0)
    }
    
    // iPad Pro 12.5
    return CGFloat(-200.0)
}

extension UIButton {
    
    public func addFullBorder(side: UIButtonBorderSide, borderColor: UIColor, borderWidth: CGFloat) {
        let border = CALayer()
        border.backgroundColor = borderColor.cgColor
        
        let widthDiff = getBorderDiff()
        let buttonWidth = frame.size.width - widthDiff
        
        switch side {
        case .Top:
            border.frame = CGRect(x: 0, y: 0, width: buttonWidth, height: borderWidth)
        case .Bottom:
            border.frame = CGRect(x: 0, y: frame.size.height - borderWidth, width: buttonWidth, height: borderWidth)
        case .Left:
            border.frame = CGRect(x: 0, y: 0, width: borderWidth, height: frame.size.height)
        case .Right:
            border.frame = CGRect(x: buttonWidth, y: 0, width: borderWidth, height: frame.size.height)
        }
        
        self.layer.addSublayer(border)
    }
    
    public func addTwoThirdsBorder(side: UIButtonBorderSide, borderColor: UIColor, borderWidth: CGFloat) {
        let border = CALayer()
        border.backgroundColor = borderColor.cgColor
        
        let widthDiff = getBorderDiff()
        let buttonWidth = frame.size.width - widthDiff
        
        let horizontalStart = buttonWidth / 6.0
        let horizontalLength = (2.0 / 3.0) * buttonWidth
        
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
            border.frame = CGRect(x: buttonWidth, y: verticalStart, width: borderWidth, height: verticalLength)
        }
        self.layer.addSublayer(border)
    }
    
    public func addGroundNumsTwoThirdsBorder(side: UIButtonBorderSide, borderColor: UIColor, borderWidth: CGFloat) {
        let border = CALayer()
        border.backgroundColor = borderColor.cgColor
        
        let widthDiff = getBorderDiff()
        let buttonWidth = frame.size.width - widthDiff
        
        let horizontalStart = buttonWidth / 6.0
        let horizontalLength = (2.0 / 3.0) * buttonWidth
        
        let verticalLength = (4.0 / 5.0) * frame.size.height
        
        switch side {
        case .Top:
            border.frame = CGRect(x: horizontalStart, y: 0, width: horizontalLength, height: borderWidth)
        case .Bottom:
            border.frame = CGRect(x: horizontalStart, y: frame.size.height - borderWidth, width: horizontalLength, height: borderWidth)
        case .Left:
            border.frame = CGRect(x: 0, y: 0, width: borderWidth, height: verticalLength)
        case .Right:
            border.frame = CGRect(x: buttonWidth, y: 0, width: borderWidth, height: verticalLength)
        }
        self.layer.addSublayer(border)
    }
}

extension UILabel {
    
    public func addFullBorder(side: UIButtonBorderSide, borderColor: UIColor, borderWidth: CGFloat) {
        let border = CALayer()
        border.backgroundColor = borderColor.cgColor
        
        let widthDiff = getBorderDiff()
        let buttonWidth = frame.size.width - widthDiff
        
        switch side {
        case .Top:
            border.frame = CGRect(x: 0, y: 0, width: buttonWidth, height: borderWidth)
        case .Bottom:
            border.frame = CGRect(x: 0, y: frame.size.height - borderWidth, width: buttonWidth, height: borderWidth)
        case .Left:
            border.frame = CGRect(x: 0, y: 0, width: borderWidth, height: frame.size.height)
        case .Right:
            border.frame = CGRect(x: buttonWidth, y: 0, width: borderWidth, height: frame.size.height)
        }
        
        self.layer.addSublayer(border)
    }
    
    public func addTwoThirdsBorder(side: UIButtonBorderSide, borderColor: UIColor, borderWidth: CGFloat) {
        let border = CALayer()
        border.backgroundColor = borderColor.cgColor
        
        let widthDiff = getBorderDiff()
        let buttonWidth = frame.size.width - widthDiff
        
        let horizontalStart = buttonWidth / 6.0
        let horizontalLength = (2.0 / 3.0) * buttonWidth
        
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
        
        let widthDiff = getBorderDiff()
        let buttonWidth = frame.size.width - widthDiff
        
        let horizontalStart = buttonWidth / 6.0
        let horizontalLength = (2.0 / 3.0) * buttonWidth
        
        let verticalLength = (4.0 / 5.0) * frame.size.height
        
        switch side {
        case .Top:
            border.frame = CGRect(x: horizontalStart, y: 0, width: horizontalLength, height: borderWidth)
        case .Bottom:
            border.frame = CGRect(x: horizontalStart, y: frame.size.height - borderWidth, width: horizontalLength, height: borderWidth)
        case .Left:
            border.frame = CGRect(x: 0, y: 0, width: borderWidth, height: verticalLength)
        case .Right:
            border.frame = CGRect(x: buttonWidth, y: 0, width: borderWidth, height: verticalLength)
        }
        self.layer.addSublayer(border)
    }
}
