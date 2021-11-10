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
    @Persisted var favorite: Bool?
    
    static func updateData(_ offset: String) {
        let urlBuilder = UrlBuilder()
        let dataModelFactory = DataModelFactory()
        guard let url = URL(string: urlBuilder.getUrl(UrlPath.characteresListUrl, offset)) else { return print("ERROR") }
        DownloadManager.shared.downloadData(urlPath: url.absoluteString) { data in
            do {
                let decoder = JSONDecoder()
                let getData = try decoder.decode(CharacterDataWrapper.self, from: data)
                let realm = try Realm()
                try getData.data?.results?.forEach{item in
                    try realm.write {
                        realm.add(dataModelFactory.makeCharacterDataModel(from: item), update: .all)
                    }
                }
            }
            
            catch {
                print(error.localizedDescription)
            }
        }
    }
}
