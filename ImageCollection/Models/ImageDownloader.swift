//
//  ImageDownloader.swift
//  ImageCollection
//
//  Created by 정재성 on 6/4/25.
//

import UIKit

final class ImageDownloader {
  let session = URLSession(configuration: .default)

  func downloadImage(_ url: URL, completion: @escaping (URL, UIImage?) -> Void) {
    let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData)
    session
      .dataTask(with: request) { data, _, _ in
        let image = data.flatMap { UIImage(data: $0) }
        DispatchQueue.main.async {
          completion(url, image)
        }
      }
      .resume()
  }
}
