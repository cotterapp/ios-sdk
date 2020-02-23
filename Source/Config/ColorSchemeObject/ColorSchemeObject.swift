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
  
    var primary: UIColor
    var accent: UIColor
    var danger: UIColor
  
    override public init() {
        self.primary = UIColor(rgb: DEFAULT_PRIMARY)
        self.accent = UIColor(rgb: DEFAULT_ACCENT)
        self.danger = UIColor(rgb: DEFAULT_DANGER)
    }
  
    public convenience init(primary: UIColor? = nil, accent: UIColor? = nil, danger: UIColor? = nil) {
        self.init()
      
        self.primary = primary ?? self.primary
        self.accent = accent ?? self.accent
        self.danger = danger ?? self.danger
    }
  
    public convenience init(primary: Int? = nil, accent: Int? = nil, danger: Int? = nil) {
        self.init()
      
        if let primaryColor = primary { self.primary = UIColor(rgb: primaryColor) }
        if let accentColor = accent { self.accent = UIColor(rgb: accentColor) }
        if let dangerColor = danger { self.danger = UIColor(rgb: dangerColor) }
    }
  
    public convenience init(primary: String? = nil, accent: String? = nil, danger: String? = nil) {
        self.init()
      
        if let primaryColor = primary { self.primary = UIColor(rgb: primaryColor) }
        if let accentColor = accent { self.accent = UIColor(rgb: accentColor) }
        if let dangerColor = danger { self.danger = UIColor(rgb: dangerColor) }
    }
}
