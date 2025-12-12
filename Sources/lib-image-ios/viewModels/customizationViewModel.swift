//
//  customizationObject.swift
//  lib-image-ios
//
//  Created by Sherlock on 08/12/2025.
//

import Foundation
import UIKit

public struct ImageCustomizationViewModel {
    var compressionValue: Double = 100.0

    var resizeValue: Double = 0.0
    
    var displayImage: UIImage = UIImage()
    var originalImage: UIImage = UIImage()
    
    mutating func setImage(_ image: UIImage) {
        originalImage = image
        displayImage = image
    }
    
    mutating func setDisplayImage(_ image: UIImage) {
        displayImage = image
    }
}
