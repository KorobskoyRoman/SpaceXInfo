//
//  UserDefaultsManager.swift
//  SpaceXInfo
//
//  Created by Roman Korobskoy on 26.04.2022.
//

import Foundation

class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    let defaults = UserDefaults.standard
    var darkMode: Bool = false
    
    func saveModeCondition() {
        print("до нажатия \(darkMode)")
        darkMode.toggle()
        print("после нажатия \(darkMode)")
        defaults.set(darkMode, forKey: "condition")
    }
}
