//
//  ComicDataModelFactory.swift
//  Marvel Heroes
//
//  Created by Александр Цыганков on 10.11.2021.
//

import Foundation
import RealmSwift

class ComicDataModelFactory {
    func makeComicDataModel(from model: Comic) -> ComicDataModel {
        let comic = ComicDataModel()
        comic.id = model.id
        comic.title = model.title
        comic.comicDescription = model.description
        comic.thumbnail = model.thumbnail?.url?.absoluteString
        
        return comic
    }
    
    func updateComicDataModel(from networkModel: Comic, to realModel: ComicDataModel) -> ComicDataModel {
        // - Put new vaulues to DataModel incase of changes. This helps to avoid extra tableView reload.
        if (realModel.title != networkModel.title) {realModel.title = networkModel.title}
        if (realModel.comicDescription != networkModel.description) {realModel.comicDescription = networkModel.description}
        if (realModel.thumbnail != networkModel.thumbnail?.url?.absoluteString) {realModel.thumbnail = networkModel.thumbnail?.url?.absoluteString}
        
        return realModel
    }
}
