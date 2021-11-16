//
//  CharacterService.swift
//  Marvel Heroes
//
//  Created by Александр Цыганков on 10.11.2021.
//

import Foundation
import RealmSwift

class CharacterService {
    func updateData(_ offset: Int) {
        let urlBuilder = UrlBuilder()
        let dataModelFactory = CharacterDataModelFactory()
        guard let url = URL(string: urlBuilder.getUrl(UrlPath.characteresListUrl, offset)) else { return print("ERROR") }
        DownloadManager.shared.downloadData(urlPath: url.absoluteString) { data in
            do {
                let decoder = JSONDecoder()
                let getData = try decoder.decode(CharacterDataWrapper.self, from: data)
                let realm = try Realm()
                try getData.data?.results?.forEach{item in
                    // - If item do not exist at DataModel
                    let currentDataItem = realm.object(ofType: CharacterDataModel.self, forPrimaryKey: item.id)
                    if (currentDataItem == nil)
                    {   // - Create a new object
                        try realm.write {
                            realm.add(dataModelFactory.makeCharacterDataModel(from: item), update: .modified)
                        }
                    } else { // - Update existent DataModel properties from JSON
                        try realm.write {
                            realm.add(dataModelFactory.updateCharacterDataModel(from: item, to: currentDataItem!), update: .modified)
                        }
                    }
                }
            }
            catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func searchCharacter(by name: String) {
        // Access Shared Defaults Object
        let userDefaults = UserDefaults.standard
        let urlBuilder = UrlBuilder()
        guard let url = URL(string: urlBuilder.getUrl(UrlPath.characteresListUrl, 0, queryCharacter: name)) else { return print("ERROR") }
        var characters: [Character] = []
        let semaphore = DispatchSemaphore(value: 0)
        DownloadManager.shared.downloadData(urlPath: url.absoluteString) { data in
            do {
                let decoder = JSONDecoder()
                let getData = try decoder.decode(CharacterDataWrapper.self, from: data)
                // - Decode from JSON to array of struct
                try getData.data?.results?.forEach{item in
                    characters.append(item)
                }
                
                // - Encode to save at UserDefaults
                let encoder = JSONEncoder()
                do {
                    let encodedCharacters = try encoder.encode(characters)
                    userDefaults.set(encodedCharacters, forKey: "characterSearch")
                }
                semaphore.signal()
            }
            catch {
                print(error.localizedDescription)
            }
        }
        semaphore.wait()
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
    
    func getSearchItems(index: Int) -> Character {
        let items = UserDefaults.standard.data(forKey: "characterSearch")!
        let decoder = JSONDecoder()
        let decoded = try? decoder.decode([Character].self, from: items)
        
        return decoded![index]
    }
    
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
    
    func makeUnfavorite(characterDataModel: CharacterDataModel) -> Bool{
        let userDefaults = UserDefaults.standard
        var favorites: [String] = userDefaults.stringArray(forKey: "characterFavorites") ?? []
        favorites.removeAll { $0 == String(characterDataModel.id!) }
        userDefaults.set(favorites, forKey: "characterFavorites")
        
        return true
    }
    
    func getCharacterFavoriteCount() -> Int {
        return UserDefaults.standard.stringArray(forKey: "characterFavorites")!.count
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
    
    func passCharacterItem(from character: CharacterDataModel) -> Array<String?>{
        return [character.name, character.charDescription, character.thumbnail]
    }
}
