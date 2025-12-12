//
//  customizationObject.swift
//  lib-image-ios
//
//  Created by Sherlock on 08/12/2025.
//

import Foundation
import UIKit

public struct ImageCustomizationViewModel {
    var compressionValue: Double = 50.0

    var resizeValue: Double = 50.0
    
    public var displayImage: UIImage = UIImage()
    var originalImage: UIImage = UIImage()
    
    var (wr, hr) = (0, 0)
    
    public init(){}
    
    public mutating func setImage(_ image: UIImage) {
        originalImage = image
        (wr, hr) = simplifiedImageRatio(image)
        edit()
        displayImage = image
    }
    
    private mutating func edit() {
        let targetSize: CGFloat = 500.0
        if(originalImage.size.width > targetSize || originalImage.size.height > targetSize) {
            if(originalImage.size.width > originalImage.size.height) {
                let width = targetSize
                let height = targetSize * CGFloat(hr) / CGFloat(wr)
                UIGraphicsBeginImageContext(CGSizeMake(width, height))
                originalImage.draw(in: CGRectMake(0, 0, width, height))
                originalImage = UIGraphicsGetImageFromCurrentImageContext()!
                UIGraphicsEndImageContext()
            } else {
                let height = targetSize
                let width = targetSize * CGFloat(wr) / CGFloat(hr)
                UIGraphicsBeginImageContext(CGSizeMake(width, height))
                originalImage.draw(in: CGRectMake(0, 0, width, height))
                originalImage = UIGraphicsGetImageFromCurrentImageContext()!
                UIGraphicsEndImageContext()
            }
        }
    }
    
    public mutating func setDisplayImage(_ image: UIImage) {
        displayImage = image
    }
    
    private func simplifiedImageRatio(_ image: UIImage) -> (Int, Int) {
        let w = Int(image.size.width)
        let h = Int(image.size.height)

        func gcd(_ a: Int, _ b: Int) -> Int {
            b == 0 ? a : gcd(b, a % b)
        }

        let g = gcd(w, h)
        return (w / g, h / g)
    }

    
}
