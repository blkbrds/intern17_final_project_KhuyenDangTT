//
//  AppDelegate.swift
//  FinalProject
//
//  Created by Bien Le Q. on 8/26/19.
//  Copyright © 2019 Asiantech. All rights reserved.
//

import UIKit
import SVProgressHUD

typealias HUD = SVProgressHUD

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)

        let homeVC = HomeViewController()
        let homeViewModel = HomeViewModel()
        homeVC.viewModel = homeViewModel
        let homeNavi = UINavigationController(rootViewController: homeVC)
        homeVC.tabBarItem = UITabBarItem(title: "Home", image: UIImage(named: "home"), selectedImage: UIImage(named: "home_fill"))
        
        let searchVC = SearchViewController()
        let searchNavi = UINavigationController(rootViewController: searchVC)
        searchVC.tabBarItem = UITabBarItem(title: "Search", image: UIImage(named: "search"), selectedImage: UIImage(named: "search_fill"))
        
        let favoriteVC = FavoriteViewController()
        let favoriteNavi = UINavigationController(rootViewController: favoriteVC)
        favoriteVC.tabBarItem = UITabBarItem(title: "Favorite", image: UIImage(named: "favorite"), selectedImage: UIImage(named: "favorite_fill"))
        let favoriteViewModel = FavoriteViewModel()
        favoriteVC.viewModel = favoriteViewModel
        
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [homeNavi, searchNavi, favoriteNavi]
        tabBarController.tabBar.tintColor = .black
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
        window?.backgroundColor = .white
        return true
    }
}
