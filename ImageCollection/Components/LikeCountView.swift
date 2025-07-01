//
//  LikeCountView.swift
//  ImageCollection
//
//  Created by 정재성 on 6/1/25.
//

import UIKit
import SnapKit
import Then

final class LikeCountView: UIView {
  private let imageView = UIImageView().then {
    $0.image = UIImage(systemName: "heart.fill")
    $0.tintColor = .systemRed
  }

  private let textLabel = UILabel()

  @inlinable var count: Int? {
    get { textLabel.text.flatMap { Int($0) } }
    set { textLabel.text = newValue?.formatted(.number) }
  }

  @inlinable var font: UIFont! {
    get { textLabel.font }
    set {
      imageView.preferredSymbolConfiguration = UIImage.SymbolConfiguration(font: newValue)
      textLabel.font = newValue
    }
  }

  @inlinable var textColor: UIColor! {
    get { textLabel.textColor }
    set { textLabel.textColor = newValue }
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    imageView.preferredSymbolConfiguration = UIImage.SymbolConfiguration(font: textLabel.font)

    addSubview(imageView)
    imageView.snp.makeConstraints {
      $0.top.leading.bottom.equalToSuperview()
    }

    addSubview(textLabel)
    textLabel.snp.makeConstraints {
      $0.leading.equalTo(imageView.snp.trailing).offset(4)
      $0.top.bottom.trailing.equalToSuperview()
    }
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - LikeInfoView Preview

#Preview {
  LikeCountView().then {
    $0.count = 9999
  }
}

