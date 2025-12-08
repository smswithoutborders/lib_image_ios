//
//  image.swift
//  lib-image-ios
//
//  Created by Sherlock on 08/12/2025.
//

import SwiftUI

extension Image {
    init(packageResource name: String, ofType type: String) {
        guard let path = Bundle.module.path(forResource: name, ofType: type),
              let image = UIImage(contentsOfFile: path) else {
            self.init(name)
            return
        }
        self.init(uiImage: image)
    }
}

extension UIImage {
    convenience init?(packageResource name: String, ofType type: String) {
        guard let path = Bundle.module.path(forResource: name, ofType: type) else {
            return nil
        }
        self.init(contentsOfFile: path)
    }
}
