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
    
    func searchComic(by name: String, onComplete: @escaping() -> Void) {
        // Access Shared Defaults Object
        let userDefaults = UserDefaults.standard
        let urlBuilder = UrlBuilder()
        guard let url = URL(string: urlBuilder.getUrl(UrlPath.comicsListUrl, 0, queryComic: name)) else { return print("ERROR") }
        var comics: [Comic] = []
        DownloadManager.shared.downloadData(urlPath: url.absoluteString) { data in
            do {
                let decoder = JSONDecoder()
                let getData = try decoder.decode(ComicDataWrapper.self, from: data)
                // - Decode from JSON to array of struct
                try getData.data?.results?.forEach{item in
                    comics.append(item)
                }
                
                // - Encode to save at UserDefaults
                let encoder = JSONEncoder()
                do {
                    let encodedCharacters = try encoder.encode(comics)
                    userDefaults.set(encodedCharacters, forKey: "comicSearch")
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
            item["description"] = comicViewModel.getSearchItem(index: index).description
            item["thumbnail"] = comicViewModel.getSearchItem(index: index).thumbnail?.url?.absoluteString
        }
        
        return item
    }

}
