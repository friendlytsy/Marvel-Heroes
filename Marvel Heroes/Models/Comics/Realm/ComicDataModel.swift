//
//  ComicDataModel.swift
//  Marvel Heroes
//
//  Created by Александр Цыганков on 18.10.2021.
//

import Foundation
import RealmSwift

class ComicDataModel: Object {
    @Persisted (primaryKey: true) var id: Int?
    @Persisted var title: String?
    @Persisted var comicDescription: String?
    @Persisted var thumbnail: String?
    @Persisted var favorite: Bool?
}
