//
//  ImageItemCell.swift
//  ImageCollection
//
//  Created by 정재성 on 6/1/25.
//

import UIKit
import SnapKit
import Then

final class ImageItemCell: UICollectionViewCell {
  private let imageDownloader = ImageDownloader()

  private let imageView = UIImageView().then {
    $0.contentMode = .scaleAspectFill
    $0.clipsToBounds = true
  }

  private let profileImageView = UIImageView().then {
    $0.contentMode = .scaleAspectFill
    $0.clipsToBounds = true
    $0.backgroundColor = .white
    $0.layer.cornerRadius = 10
    $0.layer.borderWidth = 1
    $0.layer.borderColor = UIColor.white.cgColor
  }

  private let userNameLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 15, weight: .bold)
    $0.textColor = .white
  }

  private let likeCountView = LikeCountView().then {
    $0.font = .systemFont(ofSize: 13, weight: .medium)
    $0.textColor = .white
  }

  var imageItem: ImageItem? {
    didSet {
      if let imageItem {
        let imageURL = imageItem.images.regular
        imageDownloader.downloadImage(imageURL) { url, image in
          if imageURL == url {
            self.imageView.image = image
          }
        }
        if let profileImageURL = imageItem.user.profileImageURL {
          imageDownloader.downloadImage(profileImageURL) { url, image in
            if profileImageURL == url {
              self.profileImageView.image = image
            }
          }
        } else {
          profileImageView.image = nil
        }
        likeCountView.isHidden = false
        likeCountView.count = imageItem.likes
      } else {
        imageView.image = nil
        profileImageView.image = nil
        profileImageView.image = nil
        likeCountView.isHidden = true
      }
      userNameLabel.text = imageItem?.user.name
    }
  }

  override var isHighlighted: Bool {
    didSet {
      UIView.animate(withDuration: 0.25) {
        if self.isHighlighted {
          self.imageView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        } else {
          self.imageView.transform = .identity
        }
      }
    }
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    contentView.backgroundColor = .placeholderText
    contentView.clipsToBounds = true
    contentView.layer.cornerRadius = 8

    // Image
    contentView.addSubview(imageView)
    imageView.snp.makeConstraints {
      $0.directionalEdges.equalToSuperview()
    }

    // Like Background
    let likeBackgroundView = UIView().then {
      $0.backgroundColor = .black.withAlphaComponent(0.5)
      $0.layer.cornerRadius = 12
    }
    contentView.addSubview(likeBackgroundView)
    likeBackgroundView.snp.makeConstraints {
      $0.top.trailing.equalToSuperview().inset(8)
    }

    // Like icon, count
    likeBackgroundView.addSubview(likeCountView)
    likeCountView.snp.makeConstraints {
      $0.top.bottom.equalToSuperview().inset(4)
      $0.leading.trailing.equalToSuperview().inset(8)
    }

    // Bottom Gradient
    let gradientView = GradientView(
      colors: [.black.withAlphaComponent(0), .black.withAlphaComponent(0.5)],
      startPoint: CGPoint(x: 0, y: 0),
      endPoint: CGPoint(x: 0, y: 1)
    )
    contentView.addSubview(gradientView)
    gradientView.snp.makeConstraints {
      $0.leading.trailing.bottom.equalToSuperview()
      $0.height.equalTo(80)
    }

    // User Image
    contentView.addSubview(profileImageView)
    profileImageView.snp.makeConstraints {
      $0.leading.bottom.equalToSuperview().inset(8)
      $0.size.equalTo(20)
    }

    // User Name
    contentView.addSubview(userNameLabel)
    userNameLabel.snp.makeConstraints {
      $0.leading.equalTo(profileImageView.snp.trailing).offset(4)
      $0.trailing.equalToSuperview().inset(8)
      $0.centerY.equalTo(profileImageView)
    }
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
    guard let imageItem else {
      return targetSize
    }
    let ratio = targetSize.width / CGFloat(imageItem.width)
    return CGSize(width: CGFloat(imageItem.width) * ratio, height: CGFloat(imageItem.height) * ratio)
  }
}

// MARK: - ImageItemCell Preview

#Preview {
  ImageItemCell().then {
    $0.imageItem = .preview
    $0.snp.makeConstraints {
      $0.size.equalTo(200)
    }
  }
}
