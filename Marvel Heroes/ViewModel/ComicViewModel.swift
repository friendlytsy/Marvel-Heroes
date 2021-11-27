//
//  ComicFavoriteService.swift
//  Marvel Heroes
//
//  Created by Александр Цыганков on 16.11.2021.
//

import Foundation
import RealmSwift

class ComicViewModel{
    func makeFavorite(isSearch: Bool, comicDataModel: Results<ComicDataModel>, index: Int) -> Bool{
        let userDefaults = UserDefaults.standard
        var favorites: [String] = userDefaults.stringArray(forKey: "comicFavorites") ?? []
        let search : [String] = userDefaults.stringArray(forKey: "comicSearch") ?? []
        // if makeFavorite not from search
        if !isSearch {
            if (!favorites.contains(String(comicDataModel[index].id!))) {
                favorites.append(String(comicDataModel[index].id!))
                userDefaults.set(favorites, forKey: "comicFavorites")
                return true
            }
        }
        // if makeFavorite from search
        if isSearch {
            if(!favorites.contains(String(search[index]))) {
                favorites.append(String(search[index]))
                userDefaults.set(favorites, forKey: "comicFavorites")
                return true
            }
        }
        return false
    }
    
    func makeUnvorite(forkey: String, index: Int) {
        let userDefaults = UserDefaults.standard
        var favorites: [String] = userDefaults.stringArray(forKey: "comicFavorites") ?? []
        favorites.remove(at: index)
        userDefaults.set(favorites, forKey: "comicFavorites")
    }
    
    func getFavorite(with id: Int) -> ComicDataModel {
        var result: ComicDataModel? = nil
        let userDefaults = UserDefaults.standard
        let favorites: [String] = userDefaults.stringArray(forKey: "comicFavorites") ?? []
        
        do {
            let realm = try Realm()
            result = realm.objects(ComicDataModel.self).filter("id == \(favorites[id])").first
        }
        catch {
            print(error.localizedDescription)
        }
        return result!
    }
    
    func getFavoriteCount(of key: String) -> Int {
        return UserDefaults.standard.stringArray(forKey: key)?.count ?? 0
    }
    
    func getSearchCount(of key: String) -> Int {
        return UserDefaults.standard.stringArray(forKey: key)?.count ?? 0
    }
    
    func getSearchItem(index: Int) -> ComicDataModel {
        var result: ComicDataModel? = nil
        let userDefaults = UserDefaults.standard
        let search: [String] = userDefaults.stringArray(forKey: "comicSearch") ?? []
        
        do {
            let realm = try Realm()
            result = realm.objects(ComicDataModel.self).filter("id == \(search[index])").first
        }
        catch {
            print(error.localizedDescription)
        }
        return result!
    }
    
    func prepareItemForSegue(where index: Int = 0) -> [String: String] {
        
        let comicFavoriteService = ComicViewModel()
        var item = ["id":"", "name":"", "description":"","thumbnail":""]
        
        item["name"] = comicFavoriteService.getFavorite(with: index).title
        item["description"] = comicFavoriteService.getFavorite(with: index).comicDescription
        item["thumbnail"] = comicFavoriteService.getFavorite(with: index).thumbnail
        
        return item
    }
    
    func cleanupSearch() {
        UserDefaults.standard.removeObject(forKey: "comicSearch")
    }
}
