//
//  CotterImages.swift
//  Cotter
//
//  Created by Raymond Andrie on 2/27/20.
//

import Foundation

class CotterImages: NSObject {
    static let instance = CotterImages()
    
    private override init() {}
    
    func getImage(for key: String) -> String {
        return Config.instance.images.image[key] ?? "Image not found."
    }
}
