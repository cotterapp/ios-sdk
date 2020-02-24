//
//  CotterColors.swift
//  Cotter
//
//  Created by Raymond Andrie on 2/23/20.
//

// Colors will be used inside the classes
class CotterColors: NSObject {
    static let instance = CotterColors()
    
    private override init() {}
    
    func getColor(for key: String) -> String {
        return Config.instance.colors.hexColor[key] ?? "#000000" // defaults to black color
    }
}
