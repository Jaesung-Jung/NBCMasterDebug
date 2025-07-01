//
//  SceneDelegate.swift
//  ImageCollection
//
//  Created by 정재성 on 6/1/25.
//

import UIKit
import Then

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  var window: UIWindow?

  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    guard let windowScene = scene as? UIWindowScene else {
      return
    }
    let newWindow = UIWindow(windowScene: windowScene)
    newWindow.rootViewController = UITabBarController().then {
      $0.viewControllers = [
        NavigationController(rootViewController: HomeViewController()).then {
          $0.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "photo.stack"), tag: 0)
        },
        NavigationController(rootViewController: FavoriteItemViewController()).then {
          $0.tabBarItem = UITabBarItem(title: "Favorite", image: UIImage(systemName: "bookmark"), tag: 0)
        }
      ]
    }
    newWindow.makeKeyAndVisible()
    window = newWindow
  }
}
