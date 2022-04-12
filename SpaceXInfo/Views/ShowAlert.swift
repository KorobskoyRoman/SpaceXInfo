//
//  ShowAlert.swift
//  SpaceXInfo
//
//  Created by Roman Korobskoy on 05.04.2022.
//

import Foundation
import UIKit

func showAlert(title: String, message: String, controller: UIViewController) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let okAction = UIAlertAction(title: "OK", style: .default)
    
    alert.addAction(okAction)
    controller.present(alert, animated: true, completion: nil)
}
