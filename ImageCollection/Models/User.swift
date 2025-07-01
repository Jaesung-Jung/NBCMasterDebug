//
//  User.swift
//  ImageCollection
//
//  Created by 정재성 on 6/1/25.
//

import Foundation

struct User: Codable {
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

  func encode(to encoder: any Encoder) throws {
    var container = encoder.container(keyedBy: StringCodingKey.self)
    try container.encode(id, forKey: "id")
    try container.encode(name, forKey: "name")
    try container.encodeIfPresent(bio, forKey: "bio")
    try container.encodeIfPresent(location, forKey: "location")
    try container.encode(totalCollections, forKey: "total_collections")
    try container.encode(totalLikes, forKey: "total_likes")
    try container.encode(totalPhotos, forKey: "total_photos")

    var profileImageContainer = container.nestedContainer(keyedBy: StringCodingKey.self, forKey: "profile_image")
    try profileImageContainer.encodeIfPresent(profileImageURL, forKey: "large")

    var socialContainer = container.nestedContainer(keyedBy: StringCodingKey.self, forKey: "social")
    try socialContainer.encodeIfPresent(social.instagram, forKey: "instagram_username")
    try socialContainer.encodeIfPresent(social.twitter, forKey: "twitter_username")
    try socialContainer.encodeIfPresent(social.portfolio, forKey: "portfolio_url")
  }
}

// MARK: - User.Social

extension User {
  struct Social: Codable, Equatable {
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
