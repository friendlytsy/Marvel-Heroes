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
        do {
            let realm = try Realm()
            // - check if this item.id exist
            if (realm.object(ofType: ComicDataModel.self, forPrimaryKey: comicDataModel.id) != nil && comicDataModel.favorite != true) {
                try realm.write {
                    comicDataModel.setValue(true, forKey: "favorite")
                }
                print(realm.configuration.fileURL!.absoluteString)
                result = true
            } else { result = false }
        }
        catch {
            print(error.localizedDescription)
        }
        return result
    }
    
    func makeUnfavorite(comicDataModel: ComicDataModel) -> Bool{
        var result = false
        do {
            let realm = try Realm()
            try realm.write {
                comicDataModel.setValue(false, forKey: "favorite")
            }
            print(realm.configuration.fileURL!.absoluteString)
            result = true
            
        }
        catch {
            print(error.localizedDescription)
        }
        return result
    }

    func getComicFavoriteCount() -> Int {
        var filter = 0
        do {
            let realm = try Realm()
            filter = (realm.objects(ComicDataModel.self).filter("favorite == true")).count
        }
        catch {
            print(error.localizedDescription)
        }
        return filter
    }
    
    func getFavorites() -> Results<ComicDataModel> {
        var result: Results<ComicDataModel>? = nil
        do {
            let realm = try Realm()
            result = realm.objects(ComicDataModel.self).filter("favorite == true")
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
