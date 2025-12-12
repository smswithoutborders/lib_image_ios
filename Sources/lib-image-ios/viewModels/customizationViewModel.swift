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
    
    public var displayImage: UIImage = UIImage()
    var originalImage: UIImage = UIImage()
    
    public init(){}
    
    public mutating func setImage(_ image: UIImage) {
        originalImage = image
        displayImage = image
    }
    
    public mutating func setDisplayImage(_ image: UIImage) {
        displayImage = image
    }
}
