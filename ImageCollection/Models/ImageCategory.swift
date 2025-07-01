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
      "배경화면"
    case .nature:
      "자연"
    case .renders3d:
      "3D 렌더링"
    case .textures:
      "텍스처"
    case .travel:
      "여행"
    case .film:
      "필름"
    case .people:
      "사람"
    case .architecture:
      "건축 및 인테리어"
    case .street:
      "거리"
    case .experimental:
      "실험적"
    }
  }
}
