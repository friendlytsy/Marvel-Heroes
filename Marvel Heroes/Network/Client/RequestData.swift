//
//  RequestData.swift
//  Marvel Heroes
//
//  Created by Александр Цыганков on 17.10.2021.
//

import Foundation
import RealmSwift

class RequestData {
    
    func doRequest() {
        
        let urlBuilder = UrlBuilder()
        let url = URL(string: urlBuilder.getUrl(UrlPath.characteresListUrl))
        let task = URLSession.shared.dataTask(with: url!, completionHandler: {(data, response, error) in
            if error != nil || data == nil {
                print("Client error")
                return
            }
            
            guard let res = response as? HTTPURLResponse, (200...299).contains(res.statusCode) else {
                print("Server error!")
                return
            }
            
            let mi = res.mimeType
            guard let mime = res.mimeType, mime == "application/json" else {
                print("Wrong MIME type! \(String(describing: mi))")
                return
            }
            
            
            // Realm
            var config = Realm.Configuration(
                schemaVersion: 1,
                migrationBlock: { migration, oldSchemaVersion in
                    if (oldSchemaVersion < 1) {}
                })
            config.deleteRealmIfMigrationNeeded = true
            
            Realm.Configuration.defaultConfiguration = config
            
            let realm = try! Realm()
            do {
                let decoder = JSONDecoder()
                let getData = try decoder.decode(CharacterDataWrapper.self, from: data!)
                print(getData.data)
                getData.data?.results?.forEach{item in
                    // - REALM data model
                    let character = CharacterDataModel()
                    
                    character.id = item.id
                    character.name = item.name
                    character.charDescription = item.description
                    character.thumbnail = item.thumbnail?.url?.absoluteString
                    
                    try! realm.write {
                        realm.add(character, update: .all)
                        try realm.commitWrite()
                    }
                    
                }
                print(realm.configuration.fileURL?.absoluteURL ?? "")
            }
            
            catch {
                print(String(describing: error))
            }
        })
        task.resume()
    }
}
