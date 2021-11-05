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
    
    static func makeFavorite(characterDataModel: CharacterDataModel) -> Bool {
        var status = true
        
        do {
            let favoriteItem = FavoriteItemDataModel()
            let realm = try Realm()
            // - check if this item.id exist at FavoriteDataModel
            if (realm.object(ofType: FavoriteItemDataModel.self, forPrimaryKey: characterDataModel.id) == nil) {
                favoriteItem.id = characterDataModel.id
                favoriteItem.itemTitle = characterDataModel.name
                favoriteItem.itemDescription = characterDataModel.charDescription
                favoriteItem.itemThumbnail = characterDataModel.thumbnail
                
                try realm.write {
                    realm.add(favoriteItem, update: .all)
                }
                print(Realm.Configuration.defaultConfiguration.fileURL!)
            } else {
                status = false
            }
        }
        catch {
            print(error.localizedDescription)
        }
        return status
    }
    
    static func makeUnfavorite(favoriteItemDataModel: FavoriteItemDataModel){
        do {
            let realm = try Realm()
            // - find object by item.id
            let objectToDelete = realm.object(ofType: FavoriteItemDataModel.self, forPrimaryKey: favoriteItemDataModel.id)!
            
            try realm.write {
                realm.delete(objectToDelete)
            }
            print(Realm.Configuration.defaultConfiguration.fileURL!)
        }
        catch {
            print(error.localizedDescription)
        }
    }
}
