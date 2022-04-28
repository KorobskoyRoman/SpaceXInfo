//
//  UIStackView + Extension.swift
//  SpaceXInfo
//
//  Created by Roman Korobskoy on 28.04.2022.
//

import Foundation
import UIKit

extension UIStackView {
    func addArrangedSubviews(_ subviews: [UIView]) {
        subviews.forEach { addArrangedSubview($0) }
    }
}
