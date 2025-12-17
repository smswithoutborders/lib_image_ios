//
//  customizationObject.swift
//  lib-image-ios
//
//  Created by Sherlock on 08/12/2025.
//

import Foundation
import UIKit
import WebP

public struct ImageCustomizationViewModel {
    var compressionValue: Double = 25.0

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
    
    public mutating func processImage() throws -> Data {
        let currentImage = originalImage
        let currentQuality = Float(compressionValue)
        
        var width = currentImage.size.width - ((resizeValue/100) * currentImage.size.width)
        var height = currentImage.size.height - ((resizeValue/100) * currentImage.size.height)
        if(width == 0) { width = 1 }
        if(height == 0) { height = 1 }

        UIGraphicsBeginImageContext(CGSizeMake(width, height))
        currentImage.draw(in: CGRectMake(0, 0, width, height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        let encoder = WebPEncoder()
        do {
            let data = try encoder.encode(
                newImage,
                config: .preset(
                    .picture,
                    quality: currentQuality
                )
            )
//            setDisplayImage(UIImage(data: data)!)
            displayImage = UIImage(data: data)!
            
            return data
        } catch {
            throw error
        }
    }
    
}
