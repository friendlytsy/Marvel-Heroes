//
//  FavoriteVCExtension.swift
//  Marvel Heroes
//
//  Created by Александр Цыганков on 04.11.2021.
//

import Foundation
import RealmSwift
import SwiftUI

extension FavoritesViewController {
    func observeRealm() {
        self.token = self.favoriteItemDataModel?.observe {  [weak self] ( changes: RealmCollectionChange) in
            guard (self?.favoritesTableView) != nil else {return}
            switch changes {
            case .initial:
                self?.favoritesTableView.reloadData()
            case .update(_, let deletions, let insertions, let modifications):
                self?.favoritesTableView.beginUpdates()
                self?.favoritesTableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }), with: .automatic)
                self?.favoritesTableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0) }), with: .automatic)
                self?.favoritesTableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }), with: .automatic)
                self?.favoritesTableView.endUpdates()
            case .error(let error):
                fatalError("\(error)")
            }
        }
    }
}
