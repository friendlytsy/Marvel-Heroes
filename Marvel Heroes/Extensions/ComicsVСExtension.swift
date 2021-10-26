//
//  ComicsViewController.swift
//  Marvel Heroes
//
//  Created by Александр Цыганков on 25.10.2021.
//

import Foundation
import RealmSwift

extension ComicsViewController {
    func observeRealm() {
        self.token = self.comicDataModel?.observe {  [weak self] ( changes: RealmCollectionChange) in
            guard (self?.comicsTableView) != nil else {return}
            switch changes {
            case .initial:
                self?.comicsTableView.reloadData()
            case .update(_, let deletions, let insertions, let modifications):
                self?.comicsTableView.beginUpdates()
                self?.comicsTableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }), with: .automatic)
                self?.comicsTableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0) }), with: .automatic)
                self?.comicsTableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }), with: .automatic)
                self?.comicsTableView.endUpdates()
            case .error(let error):
                fatalError("\(error)")
            }
        }
    }
}
