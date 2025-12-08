//
//  customizationObject.swift
//  lib-image-ios
//
//  Created by Sherlock on 08/12/2025.
//

import Foundation
import UIKit

class CustomizationViewModel: ObservableObject {
    @Published var compressionValue: Double = 100.0

    @Published var resizeValue: Double = 0.0
    
    @Published var displayImage: UIImage?
    
    @Published var originalImage: UIImage = UIImage()
}
