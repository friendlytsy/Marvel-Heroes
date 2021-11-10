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
    @Persisted var favorite: Bool?
    
    static func updateData(_ offset: String) {
        let urlBuilder = UrlBuilder()
        let dataModelFactory = DataModelFactory()
        guard let url = URL(string: urlBuilder.getUrl(UrlPath.comicsListUrl, offset)) else { return print("ERROR") }
        DownloadManager.shared.downloadData(urlPath: url.absoluteString) { data in
            do {
                let decoder = JSONDecoder()
                let getData = try decoder.decode(ComicDataWrapper.self, from: data)
                let realm = try Realm()
                try getData.data?.results?.forEach{item in
                    try realm.write {
                        realm.add(dataModelFactory.makeComicDataModel(from: item), update: .all)
                    }
                }
            }
            catch {
                print(error.localizedDescription)
            }
        }
    }
}
