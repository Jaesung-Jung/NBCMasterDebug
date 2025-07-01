//
//  NavigationController.swift
//  ImageCollection
//
//  Created by 정재성 on 6/1/25.
//

import UIKit

final class NavigationController: UINavigationController {
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationBar.prefersLargeTitles = true
  }
}
