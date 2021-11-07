//
//  FavoriteComicDataModel.swift
//  Marvel Heroes
//
//  Created by Александр Цыганков on 07.11.2021.
//

import Foundation
import RealmSwift
class FavoriteComicDataModel: Object {
    @Persisted (primaryKey: true) var id: Int?
    @Persisted var itemTitle: String?
    @Persisted var itemDescription: String?
    @Persisted var itemThumbnail: String?
    
    static func makeFavorite(comicDataModel: ComicDataModel) -> Bool {
        var status = true
        
        do {
            let favoriteComic = FavoriteComicDataModel()
            let realm = try Realm()
            // - check if this item.id exist at FavoriteDataModel
            if (realm.object(ofType: FavoriteComicDataModel.self, forPrimaryKey: comicDataModel.id) == nil) {
                favoriteComic.id = comicDataModel.id
                favoriteComic.itemTitle = comicDataModel.title
                favoriteComic.itemDescription = comicDataModel.comicDescription
                favoriteComic.itemThumbnail = comicDataModel.thumbnail
                
                try realm.write {
                    realm.add(favoriteComic, update: .all)
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
    
    static func makeUnfavorite(favoriteComicDataModel: FavoriteComicDataModel){
        do {
            let realm = try Realm()
            // - find object by item.id
            let objectToDelete = realm.object(ofType: FavoriteComicDataModel.self, forPrimaryKey: favoriteComicDataModel.id)!
            
            try realm.write {
                realm.delete(objectToDelete)
            }
        }
        catch {
            print(error.localizedDescription)
        }
    }
}
