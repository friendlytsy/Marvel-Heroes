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
                    try realm.write {
                        realm.add(dataModelFactory.makeCharacterDataModel(from: item), update: .modified)
                    }
                }
            }
            catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func prepareItemForSegue(for characterDataModel: CharacterDataModel? = nil, where index: Int = 0) -> [String: String] {
        
        let characterSearchService = CharacterSearchService()
        
        var item = ["id":"", "name":"", "description":"","thumbnail":""]
        // - if a search
        if (characterDataModel != nil) {
            item["name"] = characterDataModel?.name
            item["description"] = characterDataModel?.charDescription
            item["thumbnail"] = characterDataModel?.thumbnail
        } else {
            item["name"] = characterSearchService.getSearchItems(index: index).name
            item["description"] = characterSearchService.getSearchItems(index: index).description
            item["thumbnail"] = characterSearchService.getSearchItems(index: index).thumbnail?.url?.absoluteString
        }
        
        return item
    }
}
