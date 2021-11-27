//
//  ComicService.swift
//  Marvel Heroes
//
//  Created by Александр Цыганков on 10.11.2021.
//

import Foundation
import RealmSwift

class ComicService {
    func updateData(_ offset: Int, onComplete: @escaping() -> Void) {
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
            onComplete()
        }
    }
    
    func searchComic(by name: String, onComplete: @escaping() -> Void) {
        let userDefaults = UserDefaults.standard
        var search: [String] = userDefaults.stringArray(forKey: "characterSearch") ?? []
        let urlBuilder = UrlBuilder()
        guard let url = URL(string: urlBuilder.getUrl(UrlPath.comicsListUrl, 0, queryComic: name)) else { return print("ERROR") }
        let dataModelFactory = ComicDataModelFactory()
        DownloadManager.shared.downloadData(urlPath: url.absoluteString) { data in
            do {
                let decoder = JSONDecoder()
                let getData = try decoder.decode(ComicDataWrapper.self, from: data)
                let realm = try Realm()
                try getData.data?.results?.forEach{item in
                    try realm.write {
                        realm.add(dataModelFactory.makeComicDataModel(from: item), update: .modified)
                    }
                    if (!search.contains(String(item.id!))) {
                        search.append(String(item.id!))
                        userDefaults.set(search, forKey: "comicSearch")
                    }
                }
            }
            catch {
                print(error.localizedDescription)
            }
            onComplete()
        }
    }

    
    func prepareItemForSegue(for comicDataModel: ComicDataModel? = nil, where index: Int = 0) -> [String: String] {
        let comicViewModel = ComicViewModel()
        var item = ["id":"", "name":"", "description":"","thumbnail":""]
        // - if a search
        if (comicDataModel != nil) {
            item["name"] = comicDataModel?.title
            item["description"] = comicDataModel?.comicDescription
            item["thumbnail"] = comicDataModel?.thumbnail
        } else {
            item["name"] = comicViewModel.getSearchItem(index: index).title
            item["description"] = comicViewModel.getSearchItem(index: index).comicDescription
            item["thumbnail"] = comicViewModel.getSearchItem(index: index).thumbnail
        }
        return item
    }

}
