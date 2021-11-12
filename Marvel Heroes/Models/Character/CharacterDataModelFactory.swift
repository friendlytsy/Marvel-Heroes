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
        
    func updateCharacterDataModel(from networkModel: Character, to realModel: CharacterDataModel) -> CharacterDataModel {
        // - Put new vaulues to DataModel incase of changes. This helps to avoid extra tableView reload.
        if (realModel.name != networkModel.name) {realModel.name = networkModel.name}
        if (realModel.charDescription != networkModel.description) {realModel.charDescription = networkModel.description}
        if (realModel.thumbnail != networkModel.thumbnail?.url?.absoluteString) {realModel.thumbnail = networkModel.thumbnail?.url?.absoluteString}
        
        return realModel
    }
}
