//
//
//  UIImageView + Additions.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 18/11/25.
//  Contact me if anything is needed: 
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2025 Md. Abir Hossain. All rights reserved.
//


import UIKit

extension UIImageView {
    func setImage(from urlString: String, placeholder: UIImage? = nil) {
        
        // set placeholder
        self.image = placeholder
        
        // check cache first
        if let cachedImage = ImageCacheManager.shared.image(forKey: urlString) {
            self.image = cachedImage
            return
        }
        
        // download image
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let self = self,
                  let data = data,
                  let image = UIImage(data: data),
                  error == nil else { return }
            
            // cache the image
            ImageCacheManager.shared.setImage(image, forKey: urlString)
            
            // set image on main thread
            DispatchQueue.main.async {
                self.image = image
            }
        }
        .resume()
    }
}
