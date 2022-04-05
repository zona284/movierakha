//
//  ExtensionHelper.swift
//  movierakha
//
//  Created by Mohammad Rakha Mauludi on 05/04/22.
//

import Foundation
import UIKit

let imageCache = NSCache<NSString, UIImage>()
extension UIImageView {
    func rounded(cornerRadius radius: CGFloat) {
        self.layer.masksToBounds = false
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }
    
    func downloaded(from url: URL, contentMode mode: ContentMode = .scaleAspectFit) {
        let activityIndicator = UIActivityIndicatorView.init(style: UIActivityIndicatorView.Style.medium)
        addSubview(activityIndicator)
        activityIndicator.startAnimating()
        activityIndicator.center = self.center
        
        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString)  {
            self.image = cachedImage
            return
        }
        
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                imageCache.setObject(image, forKey: url.absoluteString as NSString)
                self?.image = image
                activityIndicator.removeFromSuperview()
            }
        }.resume()
    }
    
    func downloaded(from link: String, contentMode mode: ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}

