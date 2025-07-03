//
//  ImageCollectionViewController.swift
//  ImageCollection
//
//  Created by 정재성 on 6/1/25.
//

import UIKit
import SnapKit
import Then

final class ImageCollectionViewController: UIViewController {
  private let repository: ImageRepository
  private let category: ImageCategory

  private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: makeCollectionViewLayout()).then {
    $0.delegate = self
    $0.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
  }

  private lazy var dataSource = makeCollectionViewDataSource(collectionView)

  init(category: ImageCategory) {
    self.repository = ImageRepository()
    self.category = category
    super.init(nibName: nil, bundle: nil)
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    title = "\(category)"
    view.backgroundColor = .systemBackground

    view.addSubview(collectionView)
    collectionView.snp.makeConstraints {
      $0.directionalEdges.equalToSuperview()
    }

    navigationItem.rightBarButtonItem = UIBarButtonItem(
      title: nil,
      image: UIImage(systemName: "arrow.trianglehead.2.counterclockwise.rotate.90"),
      primaryAction: UIAction { [unowned self] _ in
        fetchImages()
      },
      menu: nil
    )
    fetchImages(page: 1)
  }
}

// MARK: - ImageCollectionViewController (UICollectionViewDelegate)

extension ImageCollectionViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    guard let imageItem = dataSource.itemIdentifier(for: indexPath) else {
      return
    }
    let detailViewController = ImageDetailViewController(imageItem: imageItem)
    navigationController?.pushViewController(detailViewController, animated: true)
  }
}

// MARK: - ImageCollectionViewController (Private)

extension ImageCollectionViewController {
  @objc private func refreshImages() {
    fetchImages()
  }

  private func fetchImages(page: Int? = nil) {
    repository.fetchImages(category: category, page: page) { [weak self] result in
      guard let self else {
        return
      }
      let images: [ImageItem]
      switch result {
      case .success(let items):
        images = items
      case .failure:
        images = []
      }
      DispatchQueue.main.async {
        self.updateImages(images)
      }
    }
  }

  private func updateImages(_ images: [ImageItem]) {
    var snapshot = NSDiffableDataSourceSnapshot<Int, ImageItem>()
    snapshot.appendSections([0])
    snapshot.appendItems(images, toSection: 0)
    dataSource.apply(snapshot)
  }

  private func makeCollectionViewDataSource(_ collectionView: UICollectionView) -> UICollectionViewDiffableDataSource<Int, ImageItem> {
    let cellRegistration = UICollectionView.CellRegistration<ImageItemCell, ImageItem> { cell, _, imageItem in
      cell.imageItem = imageItem
    }
    return UICollectionViewDiffableDataSource(collectionView: collectionView) { collectionView, indexPath, item in
      collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
    }
  }

  private func makeCollectionViewLayout() -> UICollectionViewLayout {
    UICollectionViewCompositionalLayout { _, environment in
      let containerSize = environment.container.effectiveContentSize
      let item = NSCollectionLayoutItem(
        layoutSize: NSCollectionLayoutSize(
          widthDimension: .fractionalWidth(1),
          heightDimension: .estimated(containerSize.width)
        )
      )
      let grorup = NSCollectionLayoutGroup.horizontal(
        layoutSize: NSCollectionLayoutSize(
          widthDimension: .fractionalWidth(1),
          heightDimension: .estimated(containerSize.width)
        ),
        subitems: [item]
      )
      return NSCollectionLayoutSection(group: grorup).then {
        $0.contentInsetsReference = .layoutMargins
        $0.interGroupSpacing = 10
      }
    }
  }
}

// MARK: - ImageCollectionViewController Preview

#Preview {
  NavigationController(rootViewController: ImageCollectionViewController(category: .nature))
}
