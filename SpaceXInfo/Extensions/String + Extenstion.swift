//
//  String + Extenstion.swift
//  SpaceXInfo
//
//  Created by Roman Korobskoy on 02.05.2022.
//

import UIKit

extension String {
    func localized(tableName: String) -> String {
        return NSLocalizedString(self, tableName: tableName, bundle: .main, value: "**\(self)**", comment: "")
    }
}
