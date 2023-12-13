//
//  ImageLoader.swift
//  Heroes
//
//  Created by Bernardo Vala Lourenço on 25/10/2023.
//

import Foundation
import UIKit

// Source: https://www.donnywals.com/efficiently-loading-images-in-table-views-and-collection-views/
class ImageLoader {
    private var loadedImages = [URL: UIImage]()
    private var runningRequests = [UUID: URLSessionDataTask]()
    private var firstTimeLoading = [URL: Bool]()
    
    func loadImage(_ url: URL, _ completion: @escaping (Result<UIImage, Error>) -> Void) -> UUID? {
        
        if let image = loadedImages[url] {
            self.firstTimeLoading[url] = false
            completion(.success(image))
            return nil
        }
        
        let uuid = UUID()
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            defer {
                if self.runningRequests[uuid] != nil {
                    self.runningRequests.removeValue(forKey: uuid)
                }
            }
            
            // Load and return image
            if let data = data, let image = UIImage(data: data) {
                self.loadedImages[url] = image
                self.firstTimeLoading[url] = true
                completion(.success(image))
                return
            }
            
            guard let error = error else {
                // Without image and without error
                return
            }
            
            guard (error as NSError).code == NSURLErrorCancelled else {
                completion(.failure(error))
                return
            }
        }
        task.resume()
        
        runningRequests[uuid] = task
        return uuid
    }
    
    func cancelLoad(_ uuid: UUID) {
        runningRequests[uuid]?.cancel()
        runningRequests.removeValue(forKey: uuid)
    }
    
    func isFirstTimeLoading(url: URL) -> Bool {
        return self.firstTimeLoading[url] == true
    }
}
