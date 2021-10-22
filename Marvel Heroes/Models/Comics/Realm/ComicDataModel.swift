//
//  ComicDataModel.swift
//  Marvel Heroes
//
//  Created by Александр Цыганков on 18.10.2021.
//

import Foundation
import RealmSwift

class ComicDataModel: Object {
    @Persisted (primaryKey: true) var id: Int?
    @Persisted var title: String?
    @Persisted var comicDescription: String?
    @Persisted var thumbnail: String?
    
    var networkClient = NetworkClient()
    
    func updateData() {
        var config = Realm.Configuration(
            schemaVersion: 1,
            migrationBlock: { migration, oldSchemaVersion in
                if (oldSchemaVersion < 1) {}
            })
        config.deleteRealmIfMigrationNeeded = true
        
        Realm.Configuration.defaultConfiguration = config
        
        let realm = try! Realm()
        do {
            let urlBuilder = UrlBuilder()
            guard let url = URL(string: urlBuilder.getUrl(UrlPath.comicsListUrl)) else { return print("ERROR") }
            networkClient.downloadTask(url: url.absoluteString) { (json, data) in
                do {
                    let decoder = JSONDecoder()
                    let getData = try decoder.decode(ComicDataWrapper.self, from: data)
                    
                    getData.data?.results?.forEach{item in
                        // - REALM data model
                        DispatchQueue.main.async {
                            do {
                                let comic = ComicDataModel()
                                
                                comic.id = item.id
                                comic.title = item.title
                                comic.comicDescription = item.description
                                comic.thumbnail = item.thumbnail?.url?.absoluteString
                                
                                try! realm.write {
                                    realm.add(comic, update: .all)
                                    try realm.commitWrite()
                                }
                            }
                        }
                    }
                    print(realm.configuration.fileURL?.absoluteURL ?? "")
                }
                catch {
                    print(error.localizedDescription)
                    
                }
            }
        }
    }
}
