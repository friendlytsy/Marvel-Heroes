//
//  CharacterViewController.swift
//  Marvel Heroes
//
//  Created by Александр Цыганков on 25.10.2021.
//

import Foundation
import RealmSwift
import SwiftUI
import Accelerate

extension CharacterViewController {
    func observeRealm() {
        self.token = self.characterDataModel?.observe {  [weak self] ( changes: RealmCollectionChange) in
            guard (self?.characterTableView) != nil else {return}
            switch changes {
            case .initial:
                self!.characterTableView.reloadData()
            case .update(_, let deletions, let insertions, let modifications):
                self?.characterTableView.beginUpdates()
                self?.characterTableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }), with: .automatic)
                self?.characterTableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0) }), with: .automatic)
                self?.characterTableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }), with: .automatic)
                self?.characterTableView.endUpdates()
            case .error(let error):
                fatalError("\(error)")
            }
        }
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "Can't add to favorite", message: "This character already added to favorite", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
}
