//
//  ComicsViewController.swift
//  Marvel Heroes
//
//  Created by Александр Цыганков on 25.10.2021.
//

import Foundation
import RealmSwift
import SwiftUI
import Accelerate

extension ComicsViewController {
    func observeRealm() {
        let indexSelected = comicSegmentControl.selectedSegmentIndex
        switch indexSelected{
        case 0:
            self.token = self.comicDataModel?.observe {  [weak self] ( changes: RealmCollectionChange) in
                guard (self?.comicsTableView) != nil else {return}
                switch changes {
                case .initial:
                    UIView.transition(with: self!.comicsTableView,
                                      duration: 0.5,
                                      options: .transitionCrossDissolve,
                                      animations: { self!.comicsTableView.reloadData() })
                    
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
        case 1:
            self.token = self.comicDataModel?.observe {  [weak self] ( changes: RealmCollectionChange) in
                guard (self?.comicsTableView) != nil else {return}
                switch changes {
                case .initial:
                    UIView.transition(with: self!.comicsTableView,
                                      duration: 0.5,
                                      options: .transitionCrossDissolve,
                                      animations: { self!.comicsTableView.reloadData() })
                    
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
        default:
            return print("fatal error")
        }
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "Can't add to favorite", message: "This character already adde to favorite", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
}
