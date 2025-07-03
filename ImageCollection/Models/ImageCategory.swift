//
//  ImageCategory.swift
//  ImageCollection
//
//  Created by 정재성 on 6/1/25.
//

enum ImageCategory: String, CaseIterable {
  case wallpaper = "wallpapers"
  case nature
  case renders3d = "3d-renders"
  case textures = "textures-patterns"
  case travel = "travel"
  case film = "film"
  case people = "people"
  case architecture = "architecture-interior"
  case street = "street-photography"
  case experimental = "experimental"
}

// MARK: - ImageCategory (CustomStringConvertible)

extension ImageCategory: CustomStringConvertible {
  var description: String {
    switch self {
    case .wallpaper:
      "Wallpapers"
    case .nature:
      "Nature"
    case .renders3d:
      "3D Renders"
    case .textures:
      "Textures"
    case .travel:
      "Travel"
    case .film:
      "Film"
    case .people:
      "People"
    case .architecture:
      "Architecture and Interior"
    case .street:
      "Street"
    case .experimental:
      "Experimental"
    }
  }
}
