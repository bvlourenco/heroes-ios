//
//  ImageCache.swift
//  Heroes
//
//  Created by Bernardo Vala Lourenço on 25/10/2023.
//

import Foundation
import UIKit

// Source: https://stackoverflow.com/a/52416497
class ImageCache {
    
    // NSString is an object that resides in heap and always passed by reference.
    // String is a value type
    static var cache = NSCache<NSString, AnyObject>()
    
    static func imageForUrl(urlString: String, completionHandler: @escaping (_ image: UIImage?, _ url: String, _ isNotLoaded: Bool) -> ()) {
        let data: Data? = self.cache.object(forKey: urlString as NSString) as? Data
        
        if let imageData = data {
            let image = UIImage(data: imageData)
            DispatchQueue.main.async {
                completionHandler(image, urlString, false)
            }
            return
        } else {
            if let url = URL(string: urlString) {
                URLSession.shared.dataTask(with: url) { (data, response, error) in
                    if error == nil {
                        if data != nil {
                            let image = UIImage(data: data!)
                            self.cache.setObject(data! as AnyObject, forKey: urlString as NSString)
                            DispatchQueue.main.async {
                                completionHandler(image, urlString, true)
                            }
                        }
                    } else {
                        completionHandler(nil, urlString, false)
                    }
                }.resume()
            }
        }
    }
}
