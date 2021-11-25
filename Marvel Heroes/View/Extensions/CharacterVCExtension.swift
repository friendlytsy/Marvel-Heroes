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

extension CharacterViewController{
    
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

extension CharacterViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {}
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if (searchController.searchBar.text != "") {
            characterService.searchCharacter(by: searchController.searchBar.text ?? "") {
                DispatchQueue.main.async {
                    self.characterTableView.reloadData()
                }
            }
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        observeRealm()
    }
}

extension CharacterViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return characterViewModel.getSearchCount()
        }
        return characterDataModel?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = characterTableView.dequeueReusableCell(withIdentifier: "GenericTableViewCell", for: indexPath) as! GenericTableViewCell
        
        if (!searchController.isActive && searchController.searchBar.text == "") {
            cell.configureCharacter(withViewModel: (characterDataModel?[indexPath.row])!)
        } else {
            cell.configureCharacterSearchResult(result: characterViewModel.getSearchItem(index: indexPath.row))
        }
        return cell
    }
}
