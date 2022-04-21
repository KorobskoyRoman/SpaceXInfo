//
//  Section.swift
//  SpaceXInfo
//
//  Created by Roman Korobskoy on 01.04.2022.
//

enum Section: Int, CaseIterable {
    case mainSection
    
    func description() -> String {
        switch self {
        case .mainSection:
            return ""
        }
    }
}
