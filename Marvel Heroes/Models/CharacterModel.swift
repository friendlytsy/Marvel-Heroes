//
//  CharacterModel.swift
//  Marvel Heroes
//
//  Created by Alexander Tsygankov on 09.09.2021.
//

import Foundation

struct CharacterModel {
    
    var characterName: String?
    var characterDescription: String?
    
    init( _ name: String, _ description: String) {
        self.characterName = name
        self.characterDescription = description
    }
    
}
