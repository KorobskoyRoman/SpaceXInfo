//
//  UIColor + Extension.swift
//  SpaceXInfo
//
//  Created by Roman Korobskoy on 01.04.2022.
//

import Foundation
import UIKit

extension UIColor {
    static func mainWhite() -> UIColor {
        return !UserDefaults.standard.bool(forKey: UserDefaultsManager.shared.key) ?  #colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 1) : #colorLiteral(red: 0.9750153422, green: 0.9786756635, blue: 0.9938495755, alpha: 1)
//        return #colorLiteral(red: 0.9750153422, green: 0.9786756635, blue: 0.9938495755, alpha: 1)
    }
    
    static func mainBlack() -> UIColor {
        return !UserDefaults.standard.bool(forKey: UserDefaultsManager.shared.key) ? #colorLiteral(red: 0.9750153422, green: 0.9786756635, blue: 0.9938495755, alpha: 1) : #colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 1)
//        return #colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 1)
    }
    
    static func mainGray() -> UIColor {
        return !UserDefaults.standard.bool(forKey: UserDefaultsManager.shared.key) ?  #colorLiteral(red: 0.3389960229, green: 0.3748474121, blue: 0.3434354663, alpha: 1) : #colorLiteral(red: 0.7877369523, green: 0.7877556682, blue: 0.7877456546, alpha: 1)
//        return #colorLiteral(red: 0.7877369523, green: 0.7877556682, blue: 0.7877456546, alpha: 1)
    }
    
    static func mainRed() -> UIColor {
        return #colorLiteral(red: 1, green: 0.1719351113, blue: 0.4505646229, alpha: 1)
    }
    
    static func mainGreen() -> UIColor {
        return #colorLiteral(red: 0, green: 0.9355016351, blue: 0, alpha: 1)
    }
    
    static func mainBlue() -> UIColor {
        return !UserDefaults.standard.bool(forKey: UserDefaultsManager.shared.key) ?  #colorLiteral(red: 0.9580603242, green: 0.9251399636, blue: 0.7904273868, alpha: 1) : #colorLiteral(red: 0.3332670331, green: 0.3184727132, blue: 0.85743469, alpha: 1)
//        return #colorLiteral(red: 0.3332670331, green: 0.3184727132, blue: 0.85743469, alpha: 1)
    }
    
    static func secondaryBlue() -> UIColor {
        return !UserDefaults.standard.bool(forKey: UserDefaultsManager.shared.key) ?  #colorLiteral(red: 1, green: 0.9123719335, blue: 0.9793263078, alpha: 0.94) : #colorLiteral(red: 0.4030927718, green: 0.385201335, blue: 1, alpha: 1)
//        return #colorLiteral(red: 0.4030927718, green: 0.385201335, blue: 1, alpha: 1)
    }
    
    static func blueShadow() -> UIColor {
        return #colorLiteral(red: 0.1770806611, green: 0.1718432307, blue: 0.452688992, alpha: 1)
    }
}
