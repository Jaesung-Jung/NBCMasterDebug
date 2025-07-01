//
//  ImageDownloader.swift
//  ImageCollection
//
//  Created by 정재성 on 6/4/25.
//

import UIKit

final class ImageDownloader {
  let session = URLSession(configuration: .default)
  var delegate: ImageDownloader.Delegate?

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

  func downloadImage(_ url: URL) {
    downloadImage(url) { url, image in
      self.delegate?.imageDownloader(self, didFiniishDownloadingImageAt: url, image: image)
    }
  }
}

// MARK: - ImageDownloader.Delegate

extension ImageDownloader {
  protocol Delegate: NSObjectProtocol {
    func imageDownloader(_ imageDownloder: ImageDownloader, didFiniishDownloadingImageAt url: URL, image: UIImage?)
  }
}
