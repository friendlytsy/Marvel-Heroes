//
//  FavoriteItemDataModel.swift
//  Marvel Heroes
//
//  Created by Александр Цыганков on 04.11.2021.
//

import Foundation
import RealmSwift

class FavoriteItemDataModel: Object {
    @Persisted var itemTitle: String?
    @Persisted var itemDescription: String?
    @Persisted var itemthumbnail: String?

    static func makeFavorite() {
        print("makeFavorite")
    }
    
    static func makeUnfavorite() {
        
    }
    
}
