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
                    // - If item do not exist at DataModel
                    let currentDataItem = realm.object(ofType: ComicDataModel.self, forPrimaryKey: item.id)
                    if (currentDataItem == nil)
                    {   // - Create a new object
                        try realm.write {
                            realm.add(dataModelFactory.makeComicDataModel(from: item), update: .modified)
                        }
                    } else { // - Update existent DataModel properties from JSON
                        try realm.write {
                            realm.add(dataModelFactory.updateComicDataModel(from: item, to: currentDataItem!), update: .modified)
                        }
                    }
                }
            }
            catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func makeFavorite(isSearch: Bool, comicDataModel: Results<ComicDataModel>, index: Int) -> Bool{
        let userDefaults = UserDefaults.standard
        var favorites: [String] = userDefaults.stringArray(forKey: "comicFavorites") ?? []
        
        // if makeFavorite not from search
        if !isSearch {
            if (!favorites.contains(String(comicDataModel[index].id!))) {
                favorites.append(String(comicDataModel[index].id!))
                userDefaults.set(favorites, forKey: "comicFavorites")
                return true
            }
        }
        // if makeFavorite from search
        if isSearch {
            let search = UserDefaults.standard.data(forKey: "comicSearch")
            // - decode from userDefaults
            let decoder = JSONDecoder()
            let decoded = try? decoder.decode([Character].self, from: search!)
            if(!favorites.contains(String(decoded![index].id!))) {
                favorites.append(String(decoded![index].id!))
                userDefaults.set(favorites, forKey: "comicFavorites")
                return true
            }
        }
        return false
    }
    
    func makeUnfavorite(comicDataModel: ComicDataModel) -> Bool{
        let userDefaults = UserDefaults.standard
        var favorites: [String] = userDefaults.stringArray(forKey: "comicFavorites") ?? []
        favorites.removeAll { $0 == String(comicDataModel.id!) }
        userDefaults.set(favorites, forKey: "comicFavorites")
        
        return true
    }

    func getComicFavoriteCount() -> Int {
        return UserDefaults.standard.stringArray(forKey: "comicFavorites")!.count
    }
    
    func getFavorite(with id: Int) -> ComicDataModel {
        var result: ComicDataModel? = nil
        let userDefaults = UserDefaults.standard
        let favorites: [String] = userDefaults.stringArray(forKey: "comicFavorites") ?? []
        
        do {
            let realm = try Realm()
            result = realm.objects(ComicDataModel.self).filter("id == \(favorites[id])").first
        }
        catch {
            print(error.localizedDescription)
        }
        return result!
    }
    
    func passComicItem(from comic: ComicDataModel) -> Array<String?>{
        return [comic.title, comic.comicDescription, comic.thumbnail]
    }
    
    // SEARCH
    func searchComic(by name: String) {
        // Access Shared Defaults Object
        let userDefaults = UserDefaults.standard
        let urlBuilder = UrlBuilder()
        guard let url = URL(string: urlBuilder.getUrl(UrlPath.comicsListUrl, 0, queryComic: name)) else { return print("ERROR") }
        var comics: [Comic] = []
        let semaphore = DispatchSemaphore(value: 0)
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
                semaphore.signal()
            }
            catch {
                print(error.localizedDescription)
            }
        }
        semaphore.wait()
    }
    
    func getSearchCount() -> Int {
        if let items = UserDefaults.standard.data(forKey: "comicSearch") {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode([Comic].self, from: items) {
                return decoded.count
            }
        }
        return 0
    }
    
    func getSearchItems(index: Int) -> Comic {
        let items = UserDefaults.standard.data(forKey: "comicSearch")!
        let decoder = JSONDecoder()
        let decoded = try? decoder.decode([Comic].self, from: items)
        
        return decoded![index]
    }
 
}
