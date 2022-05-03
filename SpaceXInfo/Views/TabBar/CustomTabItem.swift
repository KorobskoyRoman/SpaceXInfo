//
//  CustomTabItem.swift
//  SpaceXInfo
//
//  Created by Roman Korobskoy on 28.04.2022.
//

import Foundation
import UIKit

enum CustomTabItem: String, CaseIterable {
    case search
    case library
}

extension CustomTabItem {
    var viewController: UIViewController {
        switch self {
        case .search:
            return generateNavigationController(rootViewController: MainViewController(), title: "SpaceX launches")
        case .library:
            return generateNavigationController(rootViewController: LibraryViewController(), title: "Your favorite launches")
        }
    }
    var icon: UIImage? {
        switch self {
        case .search:
            return UIImage(systemName: "magnifyingglass.circle", withConfiguration: UIImage.SymbolConfiguration(weight: .medium))!.withTintColor(.mainGray(), renderingMode: .alwaysOriginal)
        case .library:
            return UIImage(systemName: "star.square", withConfiguration: UIImage.SymbolConfiguration(weight: .medium))!.withTintColor(.mainGray(), renderingMode: .alwaysOriginal)
        }
    }
    var selectedIcon: UIImage? {
        switch self {
        case .search:
            return UIImage(systemName: "magnifyingglass.circle.fill", withConfiguration: UIImage.SymbolConfiguration(weight: .medium))!.withTintColor(.mainWhite(), renderingMode: .alwaysOriginal)
        case .library:
            return UIImage(systemName: "star.square.fill", withConfiguration: UIImage.SymbolConfiguration(weight: .medium))!.withTintColor(.mainWhite(), renderingMode: .alwaysOriginal)
        }
    }
    var name: String {
//        return self.rawValue.capitalized
        switch self {
        case .search:
            return "search".localized(tableName: "CustomTabBar").localizedCapitalized
        case .library:
            return "library".localized(tableName: "CustomTabBar").localizedCapitalized
        }
    }
    
    private func generateNavigationController(rootViewController: UIViewController, title: String) -> UIViewController {
        let navigationVC = UINavigationController(rootViewController: rootViewController)
        navigationVC.navigationBar.barTintColor = .secondaryBlue()
        navigationVC.navigationBar.tintColor = .mainWhite()
        navigationVC.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.mainWhite()]
        navigationVC.tabBarItem.title = title
        navigationVC.navigationBar.prefersLargeTitles = true
        
        if #available(iOS 11.0, *) {
            navigationVC.navigationBar.largeTitleTextAttributes = [
                NSAttributedString.Key.foregroundColor: UIColor.mainWhite(),
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 31, weight: UIFont.Weight.bold)
            ]
        }
        return navigationVC
    }
}
