//
//  ImageCacheManager.swift
//  UpaxChallenge
//
//  Created by Pablo Ramirez on 27/09/25.
//

import UIKit

final class ImageCacheManager {
    static let shared = ImageCacheManager()
    private let cache = NSCache<NSString, UIImage>()
    
    private init() { }
    
    func image(forKey key: String) -> UIImage? {
        return cache.object(forKey: key as NSString)
    }
    
    func save(_ image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as NSString)
    }
    
    func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        if let cached = image(forKey: url.absoluteString) {
            completion(cached)
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            guard let data = data, let image = UIImage(data: data) else {
                DispatchQueue.main.async { completion(nil) }
                
                return
            }
            
            self?.save(image, forKey: url.absoluteString)
            
            DispatchQueue.main.async {
                completion(image)
            }
        }.resume()
    }
}
