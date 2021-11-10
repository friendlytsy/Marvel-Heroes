//
//  DataModelFactory.swift
//  Marvel Heroes
//
//  Created by Александр Цыганков on 10.11.2021.
//

import Foundation
import RealmSwift

protocol DataModelMaking {
    func makeCharacterDataModel(from model: Character) -> CharacterDataModel
    func makeComicDataModel(from model: Comic) -> ComicDataModel
}

class DataModelFactory:DataModelMaking {
    func makeCharacterDataModel(from model: Character) -> CharacterDataModel {
        let character = CharacterDataModel()
        character.id = model.id
        character.name = model.name
        character.charDescription = model.description
        character.thumbnail = model.thumbnail?.url?.absoluteString
        character.favorite = true
         
        return character
    }
    
    func makeComicDataModel(from model: Comic) -> ComicDataModel {
        let comic = ComicDataModel()
        comic.id = model.id
        comic.title = model.title
        comic.comicDescription = model.description
        comic.thumbnail = model.thumbnail?.url?.absoluteString
        comic.favorite = false
        
        return comic
    }
    
}
