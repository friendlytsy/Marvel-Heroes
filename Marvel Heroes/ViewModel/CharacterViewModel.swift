//
//  CharacterFavoriteService.swift
//  Marvel Heroes
//
//  Created by Александр Цыганков on 16.11.2021.
//

import Foundation
import RealmSwift
import Firebase

class CharacterViewModel {
    func makeFavorite(isSearch: Bool, characterDataModel: Results<CharacterDataModel>, index: Int) -> Bool{
        let userDefaults = UserDefaults.standard
        var favorites: [String] = userDefaults.stringArray(forKey: "characterFavorites") ?? []
        
        // if makeFavorite not from search
        if !isSearch {
            if (!favorites.contains(String(characterDataModel[index].id!))) {
                favorites.append(String(characterDataModel[index].id!))
                userDefaults.set(favorites, forKey: "characterFavorites")
                return true
            }
        }
        // if makeFavorite from search
        if isSearch {
            let search = UserDefaults.standard.data(forKey: "characterSearch")
            // - decode from userDefaults
            let decoder = JSONDecoder()
            let decoded = try? decoder.decode([Character].self, from: search!)
            if(!favorites.contains(String(decoded![index].id!))) {
                favorites.append(String(decoded![index].id!))
                userDefaults.set(favorites, forKey: "characterFavorites")
                return true
            }
        }
        return false
    }
    
    func makeUnfavorite(forkey: String, index: Int){
        let userDefaults = UserDefaults.standard
        var favorites: [String] = userDefaults.stringArray(forKey: forkey) ?? []
        favorites.remove(at: index)
        userDefaults.set(favorites, forKey: forkey)
    }
    
    func getFavorite(with id: Int) -> CharacterDataModel {
        var result: CharacterDataModel? = nil
        let userDefaults = UserDefaults.standard
        let favorites: [String] = userDefaults.stringArray(forKey: "characterFavorites") ?? []
        
        do {
            let realm = try Realm()
            result = realm.objects(CharacterDataModel.self).filter("id == \(favorites[id])").first
        }
        catch {
            print(error.localizedDescription)
        }
        return result!
    }
    
    func getFavoriteCount(of key: String) -> Int {
        return UserDefaults.standard.stringArray(forKey: key)?.count ?? 0
    }
    
    func prepareItemForSegue(where index: Int = 0) -> [String: String] {
        
        let characterViewModel = CharacterViewModel()
        
        var item = ["id":"", "name":"", "description":"","thumbnail":""]
        
        item["name"] = characterViewModel.getFavorite(with: index).name
        item["description"] = characterViewModel.getFavorite(with: index).charDescription
        item["thumbnail"] = characterViewModel.getFavorite(with: index).thumbnail
        
        return item
    }
    
    func getSearchCount() -> Int {
        if let items = UserDefaults.standard.data(forKey: "characterSearch") {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode([Character].self, from: items) {
                return decoded.count
            }
        }
        return 0
    }
    
    func getSearchItem(index: Int) -> Character {
        let items = UserDefaults.standard.data(forKey: "characterSearch")!
        let decoder = JSONDecoder()
        let decoded = try? decoder.decode([Character].self, from: items)
        
        return decoded![index]
    }
}
