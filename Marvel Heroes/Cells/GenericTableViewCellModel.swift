//
//  GenericTableViewCellModel.swift
//  Marvel Heroes
//
//  Created by Alexander Tsygankov on 05.10.2021.
//

import Foundation
import UIKit

protocol GenericTableViewCellModel {
    var itemImage: UIImage { get }
    var itemTitle: String { get }
    var itemDescription: String { get }
}


