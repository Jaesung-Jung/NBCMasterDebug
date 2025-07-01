//
//  HomeViewController.swift
//  ImageCollection
//
//  Created by 정재성 on 6/1/25.
//

import UIKit
import SnapKit
import Then

final class HomeViewController: UIViewController {
  private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: makeCollectionViewLayout()).then {
    $0.delegate = self
    $0.backgroundColor = .clear
  }

  private lazy var dataSource = makeCollectionViewDataSource(collectionView)

  override func viewDidLoad() {
    super.viewDidLoad()
    title = "홈"
    view.backgroundColor = .systemBackground

    view.addSubview(collectionView)
    collectionView.snp.makeConstraints {
      $0.directionalEdges.equalToSuperview()
    }

    var snapshot = NSDiffableDataSourceSnapshot<Int, ImageCategory>()
    snapshot.appendSections([0])
    snapshot.appendItems(ImageCategory.allCases, toSection: 0)
    dataSource.apply(snapshot)
  }
}

// MARK: - HomeViewController (UICollectionViewDelegate)

extension HomeViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    guard let category = dataSource.itemIdentifier(for: indexPath) else {
      return
    }
    let imageCollectionViewController = ImageCollectionViewController(category: category)
    navigationController?.pushViewController(imageCollectionViewController, animated: true)
  }
}

// MARK: - HomeViewController (Private)

extension HomeViewController {
  private func makeCollectionViewDataSource(_ collectionView: UICollectionView) -> UICollectionViewDiffableDataSource<Int, ImageCategory> {
    let cellRegistration = UICollectionView.CellRegistration<ImageCategoryCell, ImageCategory> { cell, _, category in
      cell.category = category
    }
    return UICollectionViewDiffableDataSource(collectionView: collectionView) { collectionView, indexPath, item in
      collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
    }
  }

  private func makeCollectionViewLayout() -> UICollectionViewLayout {
    UICollectionViewCompositionalLayout { _, environment in
      let contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)
      let containerSize = CGSize(
        width: environment.container.effectiveContentSize.width - contentInsets.leading - contentInsets.trailing,
        height: environment.container.effectiveContentSize.height - contentInsets.top - contentInsets.bottom
      )
      let interItemSpacing: CGFloat = 10
      let itemSize = (containerSize.width - interItemSpacing) * 0.5
      let item = NSCollectionLayoutItem(
        layoutSize: NSCollectionLayoutSize(
          widthDimension: .absolute(itemSize),
          heightDimension: .absolute(itemSize)
        )
      )
      let grorup = NSCollectionLayoutGroup.horizontal(
        layoutSize: NSCollectionLayoutSize(
          widthDimension: .fractionalWidth(1),
          heightDimension: .absolute(itemSize)
        ),
        subitems: [item, item]
      ).then {
        $0.interItemSpacing = .fixed(interItemSpacing)
      }
      return NSCollectionLayoutSection(group: grorup).then {
        $0.contentInsets = contentInsets
        $0.interGroupSpacing = interItemSpacing
      }
    }
  }
}

// MARK: - HomeViewController Preview

#Preview {
  NavigationController(rootViewController: HomeViewController())
}
