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
}
