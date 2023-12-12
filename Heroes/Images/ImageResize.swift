//
//  imageResize.swift
//  Heroes
//
//  Created by Bernardo Vala Lourenço on 22/11/2023.
//

import UIKit

extension UIImage {
    // From: https://stackoverflow.com/a/40867644
    func imageWith(newSize: CGSize) -> UIImage {
        let image = UIGraphicsImageRenderer(size: newSize).image { _ in
            draw(in: CGRect(origin: .zero, size: newSize))
        }
        
        return image.withRenderingMode(renderingMode)
    }
}
