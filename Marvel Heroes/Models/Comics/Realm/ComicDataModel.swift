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
    
    //static private var networkClient = NetworkClient()
    
    static func updateData(_ offset: String) {
        let urlBuilder = UrlBuilder()
        guard let url = URL(string: urlBuilder.getUrl(UrlPath.comicsListUrl, offset)) else { return print("ERROR") }
        DownloadManager.shared.downloadData(urlPath: url.absoluteString) { data in
            do {
                let decoder = JSONDecoder()
                let getData = try decoder.decode(ComicDataWrapper.self, from: data)
                let realm = try Realm()
                try getData.data?.results?.forEach{item in
                    // - REALM data model
                    let comic = ComicDataModel()
                    
                    comic.id = item.id
                    comic.title = item.title
                    comic.comicDescription = item.description
                    comic.thumbnail = item.thumbnail?.url?.absoluteString
                    
                    try realm.write {
                        realm.add(comic, update: .all)
                    }
                }
            }
            catch {
                print(error.localizedDescription)
            }
        }
    }
}
