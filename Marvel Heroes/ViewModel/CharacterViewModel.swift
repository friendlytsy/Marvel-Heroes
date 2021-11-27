//
//  CharacterFavoriteService.swift
//  Marvel Heroes
//
//  Created by Александр Цыганков on 16.11.2021.
//

import Foundation
import RealmSwift

class CharacterViewModel {
    func makeFavorite(isSearch: Bool, characterDataModel: Results<CharacterDataModel>, index: Int) -> Bool{
        let userDefaults = UserDefaults.standard
        var favorites: [String] = userDefaults.stringArray(forKey: "characterFavorites") ?? []
        let search : [String] = userDefaults.stringArray(forKey: "characterSearch") ?? []
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
            if(!favorites.contains(String(search[index]))) {
                favorites.append(String(search[index]))
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
    
    func getSearchCount(of key: String) -> Int {
        return UserDefaults.standard.stringArray(forKey: key)?.count ?? 0
    }
    
    func getSearchItem(index: Int) -> CharacterDataModel {
        var result: CharacterDataModel? = nil
        let userDefaults = UserDefaults.standard
        let search: [String] = userDefaults.stringArray(forKey: "characterSearch") ?? []
        
        do {
            let realm = try Realm()
            result = realm.objects(CharacterDataModel.self).filter("id == \(search[index])").first
        }
        catch {
            print(error.localizedDescription)
        }
        return result!
    }
    
    func cleanupSearch() {
        UserDefaults.standard.removeObject(forKey: "characterSearch")
    }
}
