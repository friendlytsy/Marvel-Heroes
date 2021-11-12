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
    
    func makeFavorite(comicDataModel: ComicDataModel) -> Bool{
        var result = false
        
        let userDefaults = UserDefaults.standard
        var favorites: [String] = userDefaults.stringArray(forKey: "comicFavorites") ?? []

        if (!favorites.contains(String(comicDataModel.id!))) {
            favorites.append(String(comicDataModel.id!))
            userDefaults.set(favorites, forKey: "comicFavorites")
            result = true
        }
        return result
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
}
