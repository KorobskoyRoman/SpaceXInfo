//
//  RealmModel.swift
//  SpaceXInfo
//
//  Created by Roman Korobskoy on 13.04.2022.
//

import RealmSwift

class RealmModel: Object {
    @Persisted var rocket: String = ""
    @Persisted var link: String = ""
    @Persisted var success: Bool = false
    @Persisted var details: String = ""
    @Persisted var name: String = ""
    @Persisted var date: String = ""
    @Persisted var isFavorite: Bool = false
}

