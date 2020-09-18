//
//  Image.swift
//  Cotter
//
//  Created by Albert Purnama on 9/16/20.
//

import UIKit

func getUIImage(imagePath: String) -> UIImage {
    let cotterImages = ImageObject.defaultImages
    let img = cotterImages.contains(imagePath)
        ? UIImage(named: imagePath, in: Cotter.resourceBundle, compatibleWith: nil)
        : UIImage(named: imagePath, in: Bundle.main, compatibleWith: nil)
    
    return img ?? UIImage()
}
