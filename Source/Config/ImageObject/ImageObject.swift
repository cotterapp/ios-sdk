//
//  ImageObject.swift
//  Cotter
//
//  Created by Raymond Andrie on 2/27/20.
//

import Foundation

struct ImageEntity {
    var path: String
    var bundle: Bundle
}

public class ImageObject: NSObject {
    // non constant image path, allowing change of path
    var image: [String: String]

    override init() {
        self.image = [
            // MARK: - VC Image Definitions
            VCImageKey.pinSuccessImg: "default-cotter-img",
            
            // MARK: - Alert Image Definitions
            AlertImageKey.promptVerificationImg: "default-cotter-img",
            AlertImageKey.successVerificationImg: "default-cotter-img"
        ]
    }
      
    public func setImage(for key: String, to value: String) {
        print("setting \(key) to \(value)")
        self.image[key] = value
    }
}
