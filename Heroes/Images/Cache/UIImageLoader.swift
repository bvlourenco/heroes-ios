//
//  UIImageLoader.swift
//  Heroes
//
//  Created by Bernardo Vala Lourenço on 10/11/2023.
//

import Foundation
import UIKit

// Source: https://www.donnywals.com/efficiently-loading-images-in-table-views-and-collection-views/
class UIImageLoader {
    static let loader = UIImageLoader()
    
    private let imageLoader = ImageLoader()
    // Used to cancel requests.
    private var uuidMap = [UIImageView: UUID]()
    
    // Singleton object
    private init() {}
    
    func load(_ url: URL, for imageView: UIImageView) {
        
        let token = imageLoader.loadImage(url) { result in
            
            defer {
                if self.uuidMap[imageView] != nil {
                    self.uuidMap.removeValue(forKey: imageView)
                }
            }
            
            do {
                let image = try result.get()
                DispatchQueue.main.async {
                    imageView.image = image
                    
                    if self.imageLoader.isFirstTimeLoading(url: url) {
                        imageView.alpha = 0
                        UIView.animate(withDuration: 0.5,
                                       delay: 0,
                                       options: UIView.AnimationOptions.showHideTransitionViews,
                                       animations: { () -> Void in
                            imageView.alpha = 1
                        })
                    }
                }
            } catch {
                print(error)
            }
        }
        
        if let token = token {
            uuidMap[imageView] = token
        }
    }
    
    func cancel(for imageView: UIImageView) {
        if let uuid = uuidMap[imageView] {
            imageLoader.cancelLoad(uuid)
            uuidMap.removeValue(forKey: imageView)
        }
    }
}

extension UIImageView {
    func loadImage(at url: URL) {
        UIImageLoader.loader.load(url, for: self)
    }
    
    func cancelImageLoad() {
        UIImageLoader.loader.cancel(for: self)
    }
}
