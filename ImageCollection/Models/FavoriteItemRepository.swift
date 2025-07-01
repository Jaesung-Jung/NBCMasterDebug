//
//  FavoriteItemRepository.swift
//  ImageCollection
//
//  Created by 정재성 on 7/1/25.
//

import Foundation
import IdentifiedCollections

final class FavoriteItemRepository {
  private let defaults = UserDefaults()

  static let shared = FavoriteItemRepository()

  private init() {
  }

  var favoriteItems: IdentifiedArrayOf<ImageItem> {
    let items = get([ImageItem].self, for: "favorite_items") ?? []
    return IdentifiedArray(uniqueElements: items)
  }

  func favoriteItem(_ item: ImageItem) {
    var items = favoriteItems
    items.append(item)
    set(items, for: "favorite_items")
  }
}

// MARK: - FavoriteItemRepository (Private)

extension FavoriteItemRepository {
  private func set<T: Encodable>(_ item: T, for key: String) {
    let encoder = JSONEncoder()
    if let data = try? encoder.encode(item) {
      defaults.set(data, forKey: key)
    }
  }

  private func get<T: Decodable>(_ type: T.Type, for key: String) -> T? {
    guard let data = defaults.data(forKey: key) else {
      return nil
    }
    return try? JSONDecoder().decode(T.self, from: data)
  }
}
