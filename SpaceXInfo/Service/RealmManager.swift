//
//  RealmManager.swift
//  SpaceXInfo
//
//  Created by Roman Korobskoy on 13.04.2022.
//

import RealmSwift

class RealmManager {
    static let shared = RealmManager()
    var liked = [RealmModel]()
    
    private init() {}
    
    let localRealm = try! Realm()
    
    func saveLaunch(launch: RealmModel) {
        do {
            try localRealm.write({
                localRealm.add(launch)
                liked.append(launch)
                print(launch)
            })
        } catch {
            print(error)
        }
    }
}

extension Results {
    func toArray() -> [Element] {
        return compactMap { $0 }
    }
}
