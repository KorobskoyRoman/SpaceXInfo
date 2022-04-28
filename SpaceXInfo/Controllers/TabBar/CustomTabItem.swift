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
            return MainViewController()
        case .library:
            return LibraryViewController()
        }
    }
    var icon: UIImage? {
        switch self {
        case .search:
            return UIImage(systemName: "lasso.and.sparkles", withConfiguration: UIImage.SymbolConfiguration(weight: .medium))
        case .library:
            return UIImage(systemName: "square.and.arrow.down.on.square", withConfiguration: UIImage.SymbolConfiguration(weight: .medium))
        }
    }
    var selectedIcon: UIImage? {
        switch self {
        case .search:
            return UIImage(systemName: "lasso.and.sparkles.fill", withConfiguration: UIImage.SymbolConfiguration(weight: .medium))
        case .library:
            return UIImage(systemName: "square.and.arrow.down.on.square.fill", withConfiguration: UIImage.SymbolConfiguration(weight: .medium))
        }
    }
    var name: String {
        return self.rawValue.capitalized
    }
}
