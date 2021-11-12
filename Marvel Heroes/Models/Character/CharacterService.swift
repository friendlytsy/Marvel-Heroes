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
    
    func makeFavorite(characterDataModel: CharacterDataModel) -> Bool{
        var result = false
        
        let userDefaults = UserDefaults.standard
        var favorites: [String] = userDefaults.stringArray(forKey: "characterFavorites") ?? []

        if (!favorites.contains(String(characterDataModel.id!))) {
            favorites.append(String(characterDataModel.id!))
            userDefaults.set(favorites, forKey: "characterFavorites")
            result = true
        }
        return result
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
