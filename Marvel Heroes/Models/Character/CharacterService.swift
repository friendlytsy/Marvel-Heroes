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
        do {
            let realm = try Realm()
            // - check if this item.id exist
            if (realm.object(ofType: CharacterDataModel.self, forPrimaryKey: characterDataModel.id) != nil && characterDataModel.favorite != true) {
                try realm.write {
                    characterDataModel.setValue(true, forKey: "favorite")
                }
                print(realm.configuration.fileURL!.absoluteString)
                result = true
            } else { result = false }
        }
        catch {
            print(error.localizedDescription)
        }
        return result
    }
    
    func makeUnfavorite(characterDataModel: CharacterDataModel) -> Bool{
        var result = false
        do {
            let realm = try Realm()
            try realm.write {
                characterDataModel.setValue(false, forKey: "favorite")
            }
            print(realm.configuration.fileURL!.absoluteString)
            result = true
            
        }
        catch {
            print(error.localizedDescription)
        }
        return result
    }

    func getCharacterFavoriteCount() -> Int {
        var filter = 0
        do {
            let realm = try Realm()
            filter = (realm.objects(CharacterDataModel.self).filter("favorite == true")).count
        }
        catch {
            print(error.localizedDescription)
        }
        return filter
    }
    
    func getFavorites() -> Results<CharacterDataModel> {
        var result: Results<CharacterDataModel>? = nil
        do {
            let realm = try Realm()
            result = realm.objects(CharacterDataModel.self).filter("favorite == true")
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
