//
//  FavoriteItemDataModel.swift
//  Marvel Heroes
//
//  Created by Александр Цыганков on 04.11.2021.
//

import Foundation
import RealmSwift

class FavoriteItemDataModel: Object {
    @Persisted (primaryKey: true) var id: Int?
    @Persisted var itemTitle: String?
    @Persisted var itemDescription: String?
    @Persisted var itemThumbnail: String?
    
    static func makeFavorite(_ id: Int, _ name: String, _ description: String, _ thumbnail: String) -> Bool {
        do {
            let favItem = FavoriteItemDataModel()
            
            let realm = try Realm()
            
            favItem.id = id
            favItem.itemTitle = name
            favItem.itemDescription = description
            favItem.itemThumbnail = thumbnail
            
            try realm.write {
                realm.add(favItem, update: .all)
            }
            print(Realm.Configuration.defaultConfiguration.fileURL!)
        }
        catch {
            print(error.localizedDescription)
        }
        return true
    }
    
    static func makeUnfavorite() {
        
    }
    
}
