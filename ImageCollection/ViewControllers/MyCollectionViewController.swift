//
//  MyCollectionViewController.swift
//  ImageCollection
//
//  Created by 정재성 on 7/1/25.
//

import UIKit
import SnapKit
import Then

final class MyCollectionViewController: UIViewController {
  private lazy var collectionView = UICollectionView(
    frame: .zero,
    collectionViewLayout: makeCollectionVieWLayout()
  )

  private lazy var dataSource = makeCollectionViewDataSource(collectionView)

  private let emptyLabel = UILabel().then {
    $0.text = "Empty"
    $0.textColor = .systemGray
    $0.font = .systemFont(ofSize: 24, weight: .bold)
  }

  private let myCollectionRepository = MyCollectionRepository.shared

  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Favorite"

    view.addSubview(collectionView)
    collectionView.snp.makeConstraints {
      $0.directionalEdges.equalToSuperview()
    }

    view.addSubview(emptyLabel)
    emptyLabel.snp.makeConstraints {
      $0.center.equalToSuperview()
    }
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    var snapshot = NSDiffableDataSourceSnapshot<Int, ImageItem>()
    snapshot.appendSections([0])
    snapshot.appendItems(Array(myCollectionRepository.items), toSection: 0)
    dataSource.apply(snapshot)
    emptyLabel.isHidden = snapshot.numberOfItems > 0
  }
}

// MARK: - MyCollectionViewController (Private)

extension MyCollectionViewController {
  private func makeCollectionVieWLayout() -> UICollectionViewLayout {
    UICollectionViewCompositionalLayout { _, environment in
      let contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
      let spacing: CGFloat = 10
      let width = environment.container.effectiveContentSize.width - contentInsets.leading - contentInsets.trailing
      let itemSize = (width - spacing) * 0.5
      let item = NSCollectionLayoutItem(
        layoutSize: NSCollectionLayoutSize(
          widthDimension: .absolute(itemSize),
          heightDimension: .absolute(itemSize)
        )
      )
      let group = NSCollectionLayoutGroup.horizontal(
        layoutSize: NSCollectionLayoutSize(
          widthDimension: .fractionalWidth(1),
          heightDimension: .absolute(itemSize)
        ),
        subitems: [item, item]
      ).then {
        $0.contentInsets = contentInsets
        $0.interItemSpacing = .fixed(spacing)
      }
      return NSCollectionLayoutSection(group: group).then {
        $0.interGroupSpacing = spacing
      }
    }
  }

  private func makeCollectionViewDataSource(_ collectionView: UICollectionView) -> UICollectionViewDiffableDataSource<Int, ImageItem> {
    let cellRegistration = UICollectionView.CellRegistration<ImageItemCell, ImageItem> { cell, indexPath, item in
      cell.imageItem = item
    }
    return UICollectionViewDiffableDataSource<Int, ImageItem>(collectionView: collectionView) { collectionView, indexPath, item in
      collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
    }
  }
}

// MARK: - MyCollectionViewController Preview

#Preview {
  NavigationController(rootViewController: MyCollectionViewController())
}
