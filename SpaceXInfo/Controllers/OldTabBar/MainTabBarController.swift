//
//  MainTabBarController.swift
//  SpaceXInfo
//
//  Created by Roman Korobskoy on 14.04.2022.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.tintColor = .mainWhite()
        tabBar.barTintColor = .mainBlue()
        tabBar.unselectedItemTintColor = .mainGray()
        
        let mainVC = MainViewController()
        let libraryVC = LibraryViewController()
        
        let boldConfig = UIImage.SymbolConfiguration(weight: .medium)
        let launchImage = UIImage(systemName: "lasso.and.sparkles", withConfiguration: boldConfig)
        let libraryImage = UIImage(systemName: "square.and.arrow.down.on.square", withConfiguration: boldConfig)
        
        viewControllers = [generateNavigationController(rootViewController: mainVC, title: "Launches", image: launchImage!),
                           generateNavigationController(rootViewController: libraryVC, title: "Favorites", image: libraryImage!)]
    }
    
    private func generateNavigationController(rootViewController: UIViewController, title: String, image: UIImage) -> UIViewController {
        let navigationVC = UINavigationController(rootViewController: rootViewController)
        navigationVC.navigationBar.barTintColor = .secondaryBlue()
        navigationVC.navigationBar.tintColor = .mainWhite()
        navigationVC.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.mainWhite()]
        navigationVC.tabBarItem.title = title
        navigationVC.tabBarItem.image = image
        
        return navigationVC
    }
}
