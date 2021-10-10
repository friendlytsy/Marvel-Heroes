//
//  GenericTableViewCellModel.swift
//  Marvel Heroes
//
//  Created by Alexander Tsygankov on 05.10.2021.
//

import Foundation
import UIKit

protocol GenericTableViewCellModel {
    var characterImage: UIImage { get }
    var characterName: String { get }
    var characterDescription: String { get }
}


