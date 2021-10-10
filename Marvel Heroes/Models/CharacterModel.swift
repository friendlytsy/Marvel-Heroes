//
//  CharacterModel.swift
//  Marvel Heroes
//
//  Created by Alexander Tsygankov on 09.09.2021.
//

import Foundation
import UIKit

struct CharacterModel {
    
    var characterImage: UIImage
    var characterName: String
    var characterDescription: String
    
    init( _ image: UIImage, _ name: String, _ description: String) {
        self.characterImage = image
        self.characterName = name
        self.characterDescription = description
    }
    
}

extension CharacterModel: GenericTableViewCellModel {

}

