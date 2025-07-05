//
//  MyCollectionRepository.swift
//  ImageCollection
//
//  Created by 정재성 on 7/1/25.
//

import Foundation
import IdentifiedCollections

final class MyCollectionRepository {
  private let defaults = UserDefaults()

  static let shared = MyCollectionRepository()

  private init() {
  }

  var items: IdentifiedArrayOf<ImageItem> {
    let items = get([ImageItem].self, for: "my_collection") ?? []
    return IdentifiedArray(uniqueElements: items)
  }

  func appendItem(_ item: ImageItem) {
    var items = self.items
    items.append(item)
    set(items, for: "my_collection")
  }

  func removeItem(_ item: ImageItem) {
    var items = self.items
    items.remove(item)
    set(items, for: "my_collection")
  }
}

// MARK: - MyCollectionRepository (Private)

extension MyCollectionRepository {
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
