//
//  FontObject.swift
//  Cotter
//
//  Created by Albert Purnama on 7/1/20.
//

import Foundation
import UIKit

public class FontObject: NSObject {
    public var heading: UIFont = DEFAULT_COTTER_HEADING_FONT;
    public var title: UIFont = DEFAULT_COTTER_TITLE_FONT;
    public var titleLarge: UIFont = DEFAULT_COTTER_TITLE_LARGE_FONT;
    public var paragraph: UIFont = DEFAULT_COTTER_PARAGRAPH_FONT;
    public var subtitle: UIFont = DEFAULT_COTTER_SUBTITLE_FONT;
    public var subtitleLarge: UIFont = DEFAULT_COTTER_SUBTITLE_LARGE_FONT;
    public var keypad: UIFont = DEFAULT_COTTER_KEYPAD_FONT;
    public var pin: UIFont = DEFAULT_COTTER_PIN_FONT;
    public var resetPin: UIFont = DEFAULT_COTTER_RESET_PIN_FONT;
}
