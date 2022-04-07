//
//  DetailsSections.swift
//  SpaceXInfo
//
//  Created by Roman Korobskoy on 06.04.2022.
//

enum DetailsSections: Int, CaseIterable {
    case info
    
    func description() -> String {
        switch self {
        case .info:
            return "Information"
        }
    }
}
