//
//  ColorSchemeObject.swift
//  Cotter
//
//  Created by Calvin Tjoeng on 2/21/20.
//

import UIKit

public class ColorSchemeObject: NSObject {
    private let DEFAULT_PRIMARY = "#21CE99"
    private let DEFAULT_SECONDARY = "#4C2A86"
    private let DEFAULT_ACCENT = "#21CE99"
    private let DEFAULT_DANGER = "#D92C59"
    private let DEFAULT_GRAY = "#BDBDBD"
    private let DEFAULT_PIN_EMPTY = "#BDBDBD"
    private let DEFAULT_PIN_FILLED = "#693398"
    private let DEFAULT_PIN_ERROR = "#B00020"
    private let DEFAULT_NAVBAR_TINT = "#000000"
    private let DEFAULT_RESET_DEFAULT_BG = "#F5F5F5"
    private let DEFAULT_RESET_POPULATED_BG = "#DAEDC6"
    private let DEFAULT_RESET_INVALID_BG = "#F7E5E8"
    private let DEFAULT_RESET_INVALID_TEXT = "#B00020"
    private let DEFAULT_RESET_POPULATED_TEXT = "#000000"
      
    public var primary: UIColor
    public var secondary: UIColor
    public var accent: UIColor
    public var danger: UIColor
    public var gray: UIColor
    public var pinEmpty: UIColor
    public var pinFilled: UIColor
    public var pinError: UIColor
    public var navbarTint: UIColor
    public var resetDefaultBg: UIColor
    public var resetPopulatedBg: UIColor
    public var resetInvalidBg: UIColor
    public var resetInvalidText: UIColor
    public var resetPopulatedText: UIColor
  
    override public init() {
        self.primary = UIColor(rgb: DEFAULT_PRIMARY)
        self.secondary = UIColor(rgb: DEFAULT_SECONDARY)
        self.accent = UIColor(rgb: DEFAULT_ACCENT)
        self.danger = UIColor(rgb: DEFAULT_DANGER)
        self.gray = UIColor(rgb: DEFAULT_GRAY)
        self.pinEmpty = UIColor(rgb: DEFAULT_PIN_EMPTY)
        self.pinFilled = UIColor(rgb: DEFAULT_PIN_FILLED)
        self.pinError = UIColor(rgb: DEFAULT_PIN_ERROR)
        self.navbarTint = UIColor(rgb: DEFAULT_NAVBAR_TINT)
        self.resetDefaultBg = UIColor(rgb: DEFAULT_RESET_DEFAULT_BG)
        self.resetPopulatedBg = UIColor(rgb: DEFAULT_RESET_POPULATED_BG)
        self.resetInvalidBg = UIColor(rgb: DEFAULT_RESET_INVALID_BG)
        self.resetInvalidText = UIColor(rgb: DEFAULT_RESET_INVALID_TEXT)
        self.resetPopulatedText = UIColor(rgb: DEFAULT_RESET_POPULATED_TEXT)
    }
  
    public convenience init(
        primary: UIColor? = nil,
        secondary: UIColor? = nil,
        accent: UIColor? = nil,
        danger: UIColor? = nil,
        gray: UIColor? = nil,
        pinEmpty: UIColor? = nil,
        pinFilled: UIColor? = nil,
        pinError: UIColor? = nil,
        navbarTint: UIColor? = nil,
        resetDefaultBg: UIColor? = nil,
        resetPopulatedBg: UIColor? = nil,
        resetInvalidBg: UIColor? = nil,
        resetInvalidText: UIColor? = nil,
        resetPopulatedText: UIColor? = nil) {
        
        self.init()
      
        self.primary = primary ?? self.primary
        self.secondary = secondary ?? self.secondary
        self.accent = accent ?? self.accent
        self.danger = danger ?? self.danger
        self.gray = gray ?? self.gray
        self.pinEmpty = pinEmpty ?? self.pinEmpty
        self.pinFilled = pinFilled ?? self.pinFilled
        self.pinError = pinError ?? self.pinError
        self.navbarTint = navbarTint ?? self.navbarTint
        self.resetDefaultBg = resetDefaultBg ?? self.resetDefaultBg
        self.resetPopulatedBg = resetPopulatedBg ?? self.resetPopulatedBg
        self.resetInvalidBg = resetInvalidBg ?? self.resetInvalidBg
        self.resetInvalidText = resetInvalidText ?? self.resetInvalidText
        self.resetPopulatedText = resetPopulatedText ?? self.resetPopulatedText
    }
  
    public convenience init(
        primary: Int? = nil,
        secondary: Int? = nil,
        accent: Int? = nil,
        danger: Int? = nil,
        gray: Int? = nil,
        pinEmpty: Int? = nil,
        pinFilled: Int? = nil,
        pinError: Int? = nil,
        navbarTint: Int? = nil,
        resetDefaultBg: Int? = nil,
        resetPopulatedBg: Int? = nil,
        resetInvalidBg: Int? = nil,
        resetInvalidText: Int? = nil,
        resetPopulatedText: Int? = nil) {
        
        self.init()
      
        if let primaryColor = primary { self.primary = UIColor(rgb: primaryColor) }
        if let secondaryColor = secondary { self.secondary = UIColor(rgb: secondaryColor) }
        if let accentColor = accent { self.accent = UIColor(rgb: accentColor) }
        if let dangerColor = danger { self.danger = UIColor(rgb: dangerColor) }
        if let grayColor = gray { self.gray = UIColor(rgb: grayColor) }
        if let pinEmptyColor = pinEmpty { self.pinEmpty = UIColor(rgb: pinEmptyColor) }
        if let pinFilledColor = pinFilled { self.pinFilled = UIColor(rgb: pinFilledColor) }
        if let pinErrorColor = pinError { self.pinError = UIColor(rgb: pinErrorColor) }
        if let navbarTintColor = navbarTint { self.navbarTint = UIColor(rgb: navbarTintColor) }
        if let resetDefaultBgColor = resetDefaultBg { self.resetDefaultBg = UIColor(rgb: resetDefaultBgColor) }
        if let resetPopulatedBgColor = resetPopulatedBg { self.resetPopulatedBg = UIColor(rgb: resetPopulatedBgColor) }
        if let resetInvalidBgColor = resetInvalidBg { self.resetInvalidBg = UIColor(rgb: resetInvalidBgColor) }
        if let resetInvalidTextColor = resetInvalidText { self.resetInvalidText = UIColor(rgb: resetInvalidTextColor) }
        if let resetPopulatedTextColor = resetPopulatedText { self.resetPopulatedText = UIColor(rgb: resetPopulatedTextColor) }
    }
  
    public convenience init(
        primary: String? = nil,
        secondary: String? = nil,
        accent: String? = nil,
        danger: String? = nil,
        gray: String? = nil,
        pinEmpty: String? = nil,
        pinFilled: String? = nil,
        pinError: String? = nil,
        navbarTint: String? = nil,
        resetDefaultBg: String? = nil,
        resetPopulatedBg: String? = nil,
        resetInvalidBg: String? = nil,
        resetInvalidText: String? = nil,
        resetPopulatedText: String? = nil) {
        
        self.init()
      
        if let primaryColor = primary { self.primary = UIColor(rgb: primaryColor) }
        if let secondaryColor = secondary { self.secondary = UIColor(rgb: secondaryColor) }
        if let accentColor = accent { self.accent = UIColor(rgb: accentColor) }
        if let dangerColor = danger { self.danger = UIColor(rgb: dangerColor) }
        if let grayColor = gray { self.gray = UIColor(rgb: grayColor) }
        if let pinEmptyColor = pinEmpty { self.pinEmpty = UIColor(rgb: pinEmptyColor) }
        if let pinFilledColor = pinFilled { self.pinFilled = UIColor(rgb: pinFilledColor) }
        if let pinErrorColor = pinError { self.pinError = UIColor(rgb: pinErrorColor) }
        if let navbarTintColor = navbarTint { self.navbarTint = UIColor(rgb: navbarTintColor) }
        if let resetDefaultBgColor = resetDefaultBg { self.resetDefaultBg = UIColor(rgb: resetDefaultBgColor) }
        if let resetPopulatedBgColor = resetPopulatedBg { self.resetPopulatedBg = UIColor(rgb: resetPopulatedBgColor) }
        if let resetInvalidBgColor = resetInvalidBg { self.resetInvalidBg = UIColor(rgb: resetInvalidBgColor) }
        if let resetInvalidTextColor = resetInvalidText { self.resetInvalidText = UIColor(rgb: resetInvalidTextColor) }
        if let resetPopulatedTextColor = resetPopulatedText { self.resetPopulatedText = UIColor(rgb: resetPopulatedTextColor) }
    }
}
