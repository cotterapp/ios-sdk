//
//  UIImageView.swift
//  Cotter
//
//  Created by Calvin Tjoeng on 2/16/20.
//

import UIKit

let defaultImagePath = "https://cdn.arstechnica.net/wp-content/uploads/2018/06/macOS-Mojave-Dynamic-Wallpaper-transition.jpg"

extension UIImageView {
    // Code from https://stackoverflow.com/questions/24231680/loading-downloading-image-from-url-on-swift
    // TODO: load image asynchronously in the background before Cotter loads?
  
    func download(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
          
            DispatchQueue.main.async() {
                self.image = image
            }
        }.resume()
    }

    func download(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        guard let defaultImageURL = URL(string: defaultImagePath) else { return }
        guard let url = URL(string: link) else { return download(from: defaultImageURL, contentMode: mode) }

        download(from: url, contentMode: mode)
    }
}
