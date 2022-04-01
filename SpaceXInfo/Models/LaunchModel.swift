//
//  LaunchModel.swift
//  SpaceXInfo
//
//  Created by Roman Korobskoy on 01.04.2022.
//

import Foundation

//struct LaunchData: Codable {
//    let result: [Result]
//}

struct Result: Codable, Hashable {
    
    let uuid = UUID()
    let links: Links
    let rocket: String?
    let success: Bool?
    let failures: [Failure]
    let details: String?
    let name, dateUTC: String?
    
    enum CodingKeys: String, CodingKey {
        case links, rocket, success, failures, details, name
        case dateUTC = "date_utc"
    }
    
    static func == (lhs: Result, rhs: Result) -> Bool {
        lhs.uuid == rhs.uuid
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
}

struct Links: Codable {
    let patch: Patch
    let webcast: String?
    let article: String?
}

struct Failure: Codable {
    let time: Int
    let reason: String
}

struct Patch: Codable {
    let small: String?
}
