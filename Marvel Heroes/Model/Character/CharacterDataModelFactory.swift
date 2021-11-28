//
//  DataModelFactory.swift
//  Marvel Heroes
//
//  Created by Александр Цыганков on 10.11.2021.
//

import Foundation
import RealmSwift

class CharacterDataModelFactory {
    func makeCharacterDataModel(from model: Character) -> CharacterDataModel {
        let character = CharacterDataModel()
        
        character.id = model.id
        character.name = model.name
        character.charDescription = model.description
        character.thumbnail = model.thumbnail?.url?.absoluteString
         
        return character
    }
}
