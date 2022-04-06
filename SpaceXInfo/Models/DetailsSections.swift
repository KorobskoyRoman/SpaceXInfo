//
//  DetailsSections.swift
//  SpaceXInfo
//
//  Created by Roman Korobskoy on 06.04.2022.
//

enum DetailsSections: Int, CaseIterable {
    case info
    case links
    case video
    
    func description() -> String {
        switch self {
        case .info:
            return "Information"
        case .links:
            return "Links"
        case .video:
            return "Launch video"
        }
    }
}
