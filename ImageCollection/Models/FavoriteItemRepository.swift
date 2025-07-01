//
//  FavoriteItemRepository.swift
//  ImageCollection
//
//  Created by 정재성 on 7/1/25.
//

import Foundation
import Defaults
import IdentifiedCollections

final class FavoriteItemRepository {
//  private let userDefaults = UserDefaults.standard
  static let shared = FavoriteItemRepository()

  private init() {
  }

  private(set) var favoriteItems: IdentifiedArrayOf<ImageItem> = [.preview]
//  {
//    guard let items = userDefaults.array(forKey: "favorite_items") as? [ImageItem] else {
//      return []
//    }
//    return IdentifiedArray(uniqueElements: items)
//  }

  func addFavoriteItem(_ item: ImageItem) {
    favoriteItems.append(item)
//    var items = userDefaults.array(forKey: "favorite_items").flatMap { $0 as? [ImageItem] } ?? []
//    items.append(item)
//    userDefaults.set(items, forKey: "favorite_items")
  }
}
