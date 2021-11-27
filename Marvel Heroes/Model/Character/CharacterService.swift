//
//  CharacterService.swift
//  Marvel Heroes
//
//  Created by Александр Цыганков on 10.11.2021.
//

import Foundation
import RealmSwift

class CharacterService {
    func updateData(_ offset: Int, onComplete: @escaping() -> Void) {
        let urlBuilder = UrlBuilder()
        let dataModelFactory = CharacterDataModelFactory()
        guard let url = URL(string: urlBuilder.getUrl(UrlPath.characteresListUrl, offset)) else { return print("ERROR") }
        DownloadManager.shared.downloadData(urlPath: url.absoluteString) { data in
            do {
                let decoder = JSONDecoder()
                let getData = try decoder.decode(CharacterDataWrapper.self, from: data)
                let realm = try Realm()
                try getData.data?.results?.forEach{item in
                    try realm.write {
                        realm.add(dataModelFactory.makeCharacterDataModel(from: item), update: .modified)
                    }
                }
            }
            catch {
                print(error.localizedDescription)
            }
            onComplete()
        }
    }
    
    func searchCharacter(by name: String, onComplete: @escaping() -> Void) {
        // Access Shared Defaults Object
        let userDefaults = UserDefaults.standard
        let urlBuilder = UrlBuilder()
        let dataModelFactory = CharacterDataModelFactory()
        
        guard let url = URL(string: urlBuilder.getUrl(UrlPath.characteresListUrl, 0, queryCharacter: name)) else { return print("ERROR") }
        var characters: [Character] = []
        DownloadManager.shared.downloadData(urlPath: url.absoluteString) { data in
            do {
                let decoder = JSONDecoder()
                let getData = try decoder.decode(CharacterDataWrapper.self, from: data)
                let realm = try Realm()
                try getData.data?.results?.forEach{item in
                    try realm.write {
                        realm.add(dataModelFactory.makeCharacterDataModel(from: item), update: .modified)
                    }
                }
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
            }
            catch {
                print(error.localizedDescription)
            }
            onComplete()
        }
    }
    
    func prepareItemForSegue(for characterDataModel: CharacterDataModel? = nil, where index: Int = 0) -> [String: String] {
        let characterViewModel = CharacterViewModel()
        var item = ["id":"", "name":"", "description":"","thumbnail":""]
        // - if a search
        if (characterDataModel != nil) {
            item["name"] = characterDataModel?.name
            item["description"] = characterDataModel?.charDescription
            item["thumbnail"] = characterDataModel?.thumbnail
        } else {
            item["name"] = characterViewModel.getSearchItem(index: index).name
            item["description"] = characterViewModel.getSearchItem(index: index).description
            item["thumbnail"] = characterViewModel.getSearchItem(index: index).thumbnail?.url?.absoluteString
        }
        return item
    }
}
