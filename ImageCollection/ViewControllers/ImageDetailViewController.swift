//
//  ImageDetailViewController.swift
//  ImageCollection
//
//  Created by 정재성 on 6/1/25.
//

import UIKit
import SnapKit
import Then

final class ImageDetailViewController: UIViewController {
  private let imageDownloader = ImageDownloader()
  private let imageWriter = ImageWriter()
  private let favoriteItemRepository = FavoriteItemRepository.shared
  private let imageItem: ImageItem

  private let profileImageView = UIImageView().then {
    $0.contentMode = .scaleAspectFill
    $0.clipsToBounds = true
    $0.layer.cornerRadius = 20
  }

  private let userNameLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 17, weight: .semibold)
  }

  private let createdDateLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 13, weight: .semibold)
    $0.textColor = .secondaryLabel
  }

  private let likeCountView = LikeCountView().then {
    $0.font = .systemFont(ofSize: 13, weight: .semibold)
  }

  private let imageView = UIImageView().then {
    $0.backgroundColor = .systemGray6
  }

  private let descriptionLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 17, weight: .bold)
    $0.numberOfLines = 0
    $0.textAlignment = .center
  }

  private let imageSizeLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 13, weight: .medium)
    $0.textColor = .secondaryLabel
  }

  private let downloadButton = UIButton(configuration: .filled()).then {
    $0.configuration?.image = UIImage(systemName: "arrow.down.circle")
    $0.configuration?.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(
      font: .systemFont(ofSize: 17, weight: .bold)
    )
    $0.configuration?.attributedTitle = AttributedString("Download")
      .settingAttributes(AttributeContainer([.font: UIFont.systemFont(ofSize: 17, weight: .bold)]))
    $0.configuration?.imagePadding = 8
    $0.configuration?.buttonSize = .large
  }

  init(imageItem: ImageItem) {
    self.imageItem = imageItem
    super.init(nibName: nil, bundle: nil)
    self.imageWriter.delegate = self
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    title = imageItem.description ?? imageItem.user.name
    navigationItem.largeTitleDisplayMode = .never
    view.backgroundColor = .systemBackground

    navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "bookmark"), style: .plain, target: self, action: #selector(handleBookmarkBarButtonItem(_:)))

    let scrollView = UIScrollView()
    view.addSubview(scrollView)
    scrollView.snp.makeConstraints {
      $0.directionalEdges.equalToSuperview()
    }

    let contentView = UIView()
    scrollView.addSubview(contentView)
    contentView.snp.makeConstraints {
      $0.directionalEdges.equalTo(scrollView.contentLayoutGuide)
      $0.width.equalTo(scrollView.frameLayoutGuide)
      $0.height.greaterThanOrEqualTo(scrollView.safeAreaLayoutGuide).priority(.low)
    }

    // Profile Image
    contentView.addSubview(profileImageView)
    profileImageView.snp.makeConstraints {
      $0.top.equalToSuperview().inset(8)
      $0.leading.equalToSuperview().inset(16)
      $0.size.equalTo(40)
    }

    // Name
    contentView.addSubview(userNameLabel)
    userNameLabel.snp.makeConstraints {
      $0.leading.equalTo(profileImageView.snp.trailing).offset(8)
      $0.trailing.equalToSuperview().inset(16)
      $0.top.equalTo(profileImageView)
    }

    // Created date
    contentView.addSubview(createdDateLabel)
    createdDateLabel.snp.makeConstraints {
      $0.leading.equalTo(userNameLabel)
      $0.bottom.equalTo(profileImageView)
    }

    // Like
    contentView.addSubview(likeCountView)
    likeCountView.snp.makeConstraints {
      $0.centerY.equalTo(createdDateLabel)
      $0.trailing.equalToSuperview().inset(16)
    }

    // Image
    contentView.addSubview(imageView)
    imageView.snp.makeConstraints {
      $0.top.equalTo(profileImageView.snp.bottom).offset(8)
      $0.leading.trailing.equalToSuperview()
      $0.height.equalTo(imageView.snp.width).multipliedBy(CGFloat(imageItem.height) / CGFloat(imageItem.width))
    }

    // Description
    contentView.addSubview(descriptionLabel)
    descriptionLabel.snp.makeConstraints {
      $0.top.equalTo(imageView.snp.bottom).offset(8)
      $0.leading.trailing.equalToSuperview().inset(16)
    }

    // Image size
    contentView.addSubview(imageSizeLabel)
    imageSizeLabel.snp.makeConstraints {
      $0.top.equalTo(descriptionLabel.snp.bottom).offset(2)
      $0.centerX.equalTo(descriptionLabel)
    }

    // Download
    contentView.addSubview(downloadButton)
    downloadButton.snp.makeConstraints {
      $0.top.greaterThanOrEqualTo(imageSizeLabel.snp.bottom).offset(16)
      $0.leading.trailing.equalToSuperview().inset(16)
      $0.bottom.equalToSuperview().inset(16)
    }

    configure()
  }
}

// MARK: - ImageDetailViewController (ImageWrite.Delegate)

extension ImageDetailViewController: ImageWriter.Delegate {
  func imageWrite(_ imageWriter: ImageWriter, didCompleteWriteFilesWithError error: (any Error)?) {
    downloadButton.isEnabled = true
    downloadButton.configuration?.showsActivityIndicator = false
    let alertController = UIAlertController(title: "알림", message: "이미지 저장 완료!", preferredStyle: .alert)
    alertController.addAction(UIAlertAction(title: "확인", style: .default))
    present(alertController, animated: true)
  }
}

// MARK: - ImageDetailViewController (Private)

extension ImageDetailViewController {
  private func downloadImage() {
    downloadButton.isEnabled = false
    downloadButton.configuration?.showsActivityIndicator = true
    imageDownloader.downloadImage(imageItem.images.raw) { [imageWriter] _, image in
      if let image {
        imageWriter.writeImage(image)
      }
    }
  }

  private func configure() {
    let action = UIAction { [unowned self] _ in downloadImage() }
    downloadButton.addAction(action, for: .primaryActionTriggered)

    if let profileImageURL = imageItem.user.profileImageURL {
      imageDownloader.downloadImage(profileImageURL) { _, image in
        self.profileImageView.image = image
      }
    }
    userNameLabel.text = imageItem.user.name
    if let createdAt = imageItem.createdAt {
      createdDateLabel.text = createdAt.formatted(date: .abbreviated, time: .omitted)
    } else {
      createdDateLabel.text = "-"
    }

    imageDownloader.downloadImage(imageItem.images.raw) { _, image in
      self.imageView.image = image
    }

    descriptionLabel.text = imageItem.description ?? "-"
    imageSizeLabel.text = "\(imageItem.width.formatted(.number))x\(imageItem.height.formatted(.number))"
    likeCountView.count = imageItem.likes
  }

  @objc private func handleBookmarkBarButtonItem(_ sender: UIBarButtonItem) {
    favoriteItemRepository.favoriteItem(imageItem)
  }
}

// MARK: - ImageDetailViewController Preview

#Preview {
  NavigationController(rootViewController: ImageDetailViewController(imageItem: .preview))
}
