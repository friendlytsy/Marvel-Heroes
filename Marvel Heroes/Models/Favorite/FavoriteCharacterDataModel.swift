//
//  FavoriteItemDataModel.swift
//  Marvel Heroes
//
//  Created by Александр Цыганков on 04.11.2021.
//

import Foundation
import RealmSwift

class FavoriteCharacterDataModel: Object {
    @Persisted (primaryKey: true) var id: Int?
    @Persisted var itemTitle: String?
    @Persisted var itemDescription: String?
    @Persisted var itemThumbnail: String?
    
    static func makeFavorite(characterDataModel: CharacterDataModel) -> Bool {
        var status = true
        
        do {
            let favoriteCharacter = FavoriteCharacterDataModel()
            let realm = try Realm()
            // - check if this item.id exist at FavoriteDataModel
            if (realm.object(ofType: FavoriteCharacterDataModel.self, forPrimaryKey: characterDataModel.id) == nil) {
                favoriteCharacter.id = characterDataModel.id
                favoriteCharacter.itemTitle = characterDataModel.name
                favoriteCharacter.itemDescription = characterDataModel.charDescription
                favoriteCharacter.itemThumbnail = characterDataModel.thumbnail
                
                try realm.write {
                    realm.add(favoriteCharacter, update: .all)
                }
            } else {
                status = false
            }
        }
        catch {
            print(error.localizedDescription)
        }
        return status
    }
    
    static func makeUnfavorite(favoriteCharacterDataModel: FavoriteCharacterDataModel){
        do {
            let realm = try Realm()
            // - find object by item.id
            let objectToDelete = realm.object(ofType: FavoriteCharacterDataModel.self, forPrimaryKey: favoriteCharacterDataModel.id)!
            
            try realm.write {
                realm.delete(objectToDelete)
            }
        }
        catch {
            print(error.localizedDescription)
        }
    }
}
