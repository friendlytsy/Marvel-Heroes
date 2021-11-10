//
//  CharacterDataModel.swift
//  Marvel Heroes
//
//  Created by Александр Цыганков on 17.10.2021.
//

import Foundation
import RealmSwift

class CharacterDataModel: Object {
    @Persisted (primaryKey: true) var id: Int?
    @Persisted var name: String?
    @Persisted var charDescription: String?
    @Persisted var thumbnail: String?
    @Persisted var favorite: Bool?
}
