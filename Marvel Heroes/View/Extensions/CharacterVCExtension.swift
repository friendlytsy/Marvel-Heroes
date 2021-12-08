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
    func showAlert() {
        let alert = UIAlertController(title: NSLocalizedString("characterAlertTitle", comment: ""), message: NSLocalizedString("characterAlertMessage", comment: ""), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
}

extension CharacterViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {}
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        activityIndicator.startAnimating()
        characterService.searchCharacter(by: searchController.searchBar.text ?? "") {
            DispatchQueue.main.async {
                self.characterTableView.reloadData()
                self.activityIndicator.stopAnimating()
            }
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        activityIndicator.startAnimating()
        characterService.updateData(0){
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.characterTableView.reloadData()
            }
        }
        characterViewModel.cleanupSearch()
    }
}

extension CharacterViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (searchController.isActive && searchController.searchBar.text != "") {
            return characterViewModel.getSearchCount(of: "characterSearch")
        }
        return characterDataModel?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = characterTableView.dequeueReusableCell(withIdentifier: "GenericTableViewCell", for: indexPath) as! GenericTableViewCell
        if !searchController.isActive {
            cell.configureCharacter(withViewModel: (characterDataModel?[indexPath.row])!)
        } else {
            cell.configureCharacter(withViewModel: characterViewModel.getSearchItem(index: indexPath.row))
        }
        return cell
    }
}
