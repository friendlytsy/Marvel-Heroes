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
            let search = UserDefaults.standard.data(forKey: "comicSearch")
            // - decode from userDefaults
            let decoder = JSONDecoder()
            let decoded = try? decoder.decode([Character].self, from: search!)
            if(!favorites.contains(String(decoded![index].id!))) {
                favorites.append(String(decoded![index].id!))
                userDefaults.set(favorites, forKey: "comicFavorites")
                return true
            }
        }
        return false
    }
    
    func makeUnvorite(comicDataModel: ComicDataModel) -> Bool{
        let userDefaults = UserDefaults.standard
        var favorites: [String] = userDefaults.stringArray(forKey: "comicFavorites") ?? []
        favorites.removeAll { $0 == String(comicDataModel.id!) }
        userDefaults.set(favorites, forKey: "comicFavorites")
        
        return true
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
    
    func getSearchCount() -> Int {
        if let items = UserDefaults.standard.data(forKey: "comicSearch") {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode([Comic].self, from: items) {
                return decoded.count
            }
        }
        return 0
    }
    
    func getSearchItem(index: Int) -> Comic {
        let items = UserDefaults.standard.data(forKey: "comicSearch")!
        let decoder = JSONDecoder()
        let decoded = try? decoder.decode([Comic].self, from: items)
        
        return decoded![index]
    }
    
    func prepareItemForSegue(where index: Int = 0) -> [String: String] {
        
        let comicFavoriteService = ComicViewModel()
        var item = ["id":"", "name":"", "description":"","thumbnail":""]
        
        item["name"] = comicFavoriteService.getFavorite(with: index).title
        item["description"] = comicFavoriteService.getFavorite(with: index).comicDescription
        item["thumbnail"] = comicFavoriteService.getFavorite(with: index).thumbnail
        
        return item
    }
}
