//
//  UserDefaultsManager.swift
//  SpaceXInfo
//
//  Created by Roman Korobskoy on 26.04.2022.
//

import Foundation
import UIKit

class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    let defaults = UserDefaults.standard
    let key = "darkMode"
    var darkMode: Bool = false
    
    func saveModeCondition(_ sender: UISwitch) {
        defaults.set(sender.isOn, forKey: key)
        darkMode.toggle()
    }
}
