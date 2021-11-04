//
//  CharacterDataModel.swift
//  Marvel Heroes
//
//  Created by Александр Цыганков on 17.10.2021.
//

import Foundation
import RealmSwift

class CharacterDataModel: Object {
    @Persisted (primaryKey: true) var id: Int?
    @Persisted var name: String?
    @Persisted var charDescription: String?
    @Persisted var thumbnail: String?
        
    static func updateData(_ offset: String) {
        let urlBuilder = UrlBuilder()
        guard let url = URL(string: urlBuilder.getUrl(UrlPath.characteresListUrl, offset)) else { return print("ERROR") }
        DownloadManager.shared.downloadData(urlPath: url.absoluteString) { data in
            do {
                let decoder = JSONDecoder()
                let getData = try decoder.decode(CharacterDataWrapper.self, from: data)
                let realm = try Realm()
                try getData.data?.results?.forEach{item in
                    // - REALM data model
                    let character = CharacterDataModel()
                    
                    character.id = item.id
                    character.name = item.name
                    character.charDescription = item.description
                    character.thumbnail = item.thumbnail?.url?.absoluteString
                    
                    try realm.write {
                        realm.add(character, update: .all)
                    }
                }
            }
            
            catch {
                print(error.localizedDescription)
            }
        }
    }
}
