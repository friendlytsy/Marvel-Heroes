//
//  ComicService.swift
//  Marvel Heroes
//
//  Created by Александр Цыганков on 10.11.2021.
//

import Foundation
import RealmSwift

class ComicService {
    func updateData(_ offset: Int) {
        let urlBuilder = UrlBuilder()
        let dataModelFactory = ComicDataModelFactory()
        guard let url = URL(string: urlBuilder.getUrl(UrlPath.comicsListUrl, offset)) else { return print("ERROR") }
        DownloadManager.shared.downloadData(urlPath: url.absoluteString) { data in
            do {
                let decoder = JSONDecoder()
                let getData = try decoder.decode(ComicDataWrapper.self, from: data)
                let realm = try Realm()
                try getData.data?.results?.forEach{item in
                    try realm.write {
                        realm.add(dataModelFactory.makeComicDataModel(from: item), update: .modified)
                    }
                }
            }
            catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func prepareItemForSegue(for comicDataModel: ComicDataModel? = nil, where index: Int = 0) -> [String: String] {
        
        let comicSearchService = ComicSearchService()
        
        var item = ["id":"", "name":"", "description":"","thumbnail":""]
        // - if a search
        if (comicDataModel != nil) {
            item["name"] = comicDataModel?.title
            item["description"] = comicDataModel?.comicDescription
            item["thumbnail"] = comicDataModel?.thumbnail
        } else {
            item["name"] = comicSearchService.getSearchItems(index: index).title
            item["description"] = comicSearchService.getSearchItems(index: index).description
            item["thumbnail"] = comicSearchService.getSearchItems(index: index).thumbnail?.url?.absoluteString
        }
        
        return item
    }

}
