//
//  User.swift
//  ImageCollection
//
//  Created by 정재성 on 6/1/25.
//

import Foundation

struct User: Decodable {
  let id: String
  let name: String
  let bio: String?
  let location: String?
  let profileImageURL: URL?
  let totalCollections: Int
  let totalLikes: Int
  let totalPhotos: Int
  let social: Social

  init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: StringCodingKey.self)
    id = try container.decode(String.self, forKey: "id")
    name = try container.decode(String.self, forKey: "name")
    bio = try container.decodeIfPresent(String.self, forKey: "bio")
    location = try container.decodeIfPresent(String.self, forKey: "location")
    let profileImages = try container.decode([String: String].self, forKey: "profile_image")
    profileImageURL = profileImages["large"].flatMap { URL(string: $0) }
    totalCollections = try container.decode(Int.self, forKey: "total_collections")
    totalLikes = try container.decode(Int.self, forKey: "total_likes")
    totalPhotos = try container.decode(Int.self, forKey: "total_photos")

    let socialInfo = try container.decode([String: String?].self, forKey: "social").compactMapValues { $0 }
    social = Social(
      instagram: socialInfo["instagram_username"],
      twitter: socialInfo["twitter_username"],
      portfolio: socialInfo["portfolio_url"].flatMap { URL(string: $0) }
    )
  }
}

// MARK: - User.Social

extension User {
  struct Social: Decodable, Equatable {
    let instagram: String?
    let twitter: String?
    let portfolio: URL?
  }
}

// MARK: - User (Hashable)

extension User: Hashable {
  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }
}
