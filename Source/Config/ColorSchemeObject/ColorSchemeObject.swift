//
//  ColorSchemeObject.swift
//  Cotter
//
//  Created by Calvin Tjoeng on 2/21/20.
//

import Foundation

public class ColorSchemeObject: NSObject {
    private let DEFAULT_PRIMARY = "#21CE99"
    private let DEFAULT_ACCENT = "#21CE99"
    private let DEFAULT_DANGER = "#D92C59"
    private let DEFAULT_GRAY = "#BDBDBD"
    private let DEFAULT_PIN_EMPTY = "#BDBDBD"
    private let DEFAULT_PIN_FILLED = "#693398"
    private let DEFAULT_PIN_ERROR = "#B00020"
  
    public var primary: UIColor
    public var accent: UIColor
    public var danger: UIColor
    public var gray: UIColor
    public var pinEmpty: UIColor
    public var pinFilled: UIColor
    public var pinError: UIColor
  
    override public init() {
        self.primary = UIColor(rgb: DEFAULT_PRIMARY)
        self.accent = UIColor(rgb: DEFAULT_ACCENT)
        self.danger = UIColor(rgb: DEFAULT_DANGER)
        self.gray = UIColor(rgb: DEFAULT_GRAY)
        self.pinEmpty = UIColor(rgb: DEFAULT_PIN_EMPTY)
        self.pinFilled = UIColor(rgb: DEFAULT_PIN_FILLED)
        self.pinError = UIColor(rgb: DEFAULT_PIN_ERROR)
    }
  
    public convenience init(
        primary: UIColor? = nil,
        accent: UIColor? = nil,
        danger: UIColor? = nil,
        gray: UIColor? = nil,
        pinEmpty: UIColor? = nil,
        pinFilled: UIColor? = nil,
        pinError: UIColor? = nil) {
        
        self.init()
      
        self.primary = primary ?? self.primary
        self.accent = accent ?? self.accent
        self.danger = danger ?? self.danger
        self.gray = danger ?? self.gray
        self.pinEmpty = pinEmpty ?? self.pinEmpty
        self.pinFilled = pinFilled ?? self.pinFilled
        self.pinError = pinError ?? self.pinError
    }
  
    public convenience init(
        primary: Int? = nil,
        accent: Int? = nil,
        danger: Int? = nil,
        gray: Int? = nil,
        pinEmpty: Int? = nil,
        pinFilled: Int? = nil,
        pinError: Int? = nil) {
        
        self.init()
      
        if let primaryColor = primary { self.primary = UIColor(rgb: primaryColor) }
        if let accentColor = accent { self.accent = UIColor(rgb: accentColor) }
        if let dangerColor = danger { self.danger = UIColor(rgb: dangerColor) }
        if let grayColor = danger { self.gray = UIColor(rgb: grayColor) }
        if let pinEmptyColor = pinEmpty { self.pinEmpty = UIColor(rgb: pinEmptyColor) }
        if let pinFilledColor = pinFilled { self.pinFilled = UIColor(rgb: pinFilledColor) }
        if let pinErrorColor = pinError { self.pinError = UIColor(rgb: pinErrorColor) }
    }
  
    public convenience init(
        primary: String? = nil,
        accent: String? = nil,
        danger: String? = nil,
        gray: String? = nil,
        pinEmpty: String? = nil,
        pinFilled: String? = nil,
        pinError: String? = nil) {
        
        self.init()
      
        if let primaryColor = primary { self.primary = UIColor(rgb: primaryColor) }
        if let accentColor = accent { self.accent = UIColor(rgb: accentColor) }
        if let dangerColor = danger { self.danger = UIColor(rgb: dangerColor) }
        if let grayColor = danger { self.gray = UIColor(rgb: grayColor) }
        if let pinEmptyColor = pinEmpty { self.pinEmpty = UIColor(rgb: pinEmptyColor) }
        if let pinFilledColor = pinFilled { self.pinFilled = UIColor(rgb: pinFilledColor) }
        if let pinErrorColor = pinError { self.pinError = UIColor(rgb: pinErrorColor) }
    }
}
