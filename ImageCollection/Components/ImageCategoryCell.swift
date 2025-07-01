//
//  ImageCategoryCell.swift
//  ImageCollection
//
//  Created by 정재성 on 6/1/25.
//

import UIKit
import SnapKit
import Then

final class ImageCategoryCell: UICollectionViewCell {
  private let imageView = UIImageView().then {
    $0.contentMode = .scaleAspectFill
  }

  private let titleLabel = UILabel().then {
    $0.textColor = .white
    $0.font = .systemFont(ofSize: 19, weight: .bold)
  }

  var category: ImageCategory? {
    didSet {
      switch category {
      case .wallpaper:
        imageView.image = .categoryWallpaper
      case .nature:
        imageView.image = .categoryNature
      case .renders3d:
        imageView.image = .category3D
      case .textures:
        imageView.image = .categoryTexture
      case .travel:
        imageView.image = .categoryTravel
      case .film:
        imageView.image = .categoryFlim
      case .people:
        imageView.image = .categoryPeople
      case .architecture:
        imageView.image = .categoryArchitecture
      case .street:
        imageView.image = .categoryStreet
      case .experimental:
        imageView.image = .categoryExperimental
      case nil:
        imageView.image = nil
      }
      titleLabel.text = category?.description ?? "-"
    }
  }

  override var isHighlighted: Bool {
    didSet {
      UIView.animate(withDuration: 0.25) {
        if self.isHighlighted {
          self.imageView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        } else {
          self.imageView.transform = .identity
        }
      }
    }
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    contentView.clipsToBounds = true
    contentView.layer.cornerRadius = 12

    contentView.addSubview(imageView)
    imageView.snp.makeConstraints {
      $0.directionalEdges.equalToSuperview()
    }

    let gradientView = GradientView(
      colors: [.black.withAlphaComponent(0), .black.withAlphaComponent(0.5)],
      startPoint: CGPoint(x: 0, y: 0),
      endPoint: CGPoint(x: 0, y: 1)
    )
    contentView.addSubview(gradientView)
    gradientView.snp.makeConstraints {
      $0.leading.trailing.bottom.equalToSuperview()
      $0.height.equalToSuperview().multipliedBy(0.5)
    }

    contentView.addSubview(titleLabel)
    titleLabel.snp.makeConstraints {
      $0.leading.greaterThanOrEqualToSuperview().inset(8)
      $0.trailing.bottom.equalToSuperview().inset(8)
    }
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - ImageCategoryCell

#Preview {
  ImageCategoryCell().then {
    $0.category = .wallpaper
    $0.snp.makeConstraints {
      $0.size.equalTo(200)
    }
  }
}
