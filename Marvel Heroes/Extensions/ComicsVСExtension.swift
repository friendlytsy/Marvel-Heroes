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
        self.token = self.comicDataModel?.observe {  [weak self] ( changes: RealmCollectionChange) in
            guard (self?.comicsTableView) != nil else {return}
            switch changes {
            case .initial:
                self!.comicsTableView.reloadData()
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
    
    func showAlert() {
        let alert = UIAlertController(title: "Can't add to favorite", message: "This comic already added to favorites", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
}

extension ComicsViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if (searchController.searchBar.text != "") {
            comicService.searchComic(by: searchController.searchBar.text ?? "")
            comicsTableView.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        observeRealm()
    }
}

extension ComicsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return comicService.getSearchCount()
        }
        return comicDataModel?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = comicsTableView.dequeueReusableCell(withIdentifier: "GenericTableViewCell", for: indexPath) as! GenericTableViewCell
        
        if (!searchController.isActive && searchController.searchBar.text == "") {
            cell.configureComic(withViewModel: (comicDataModel?[indexPath.row])!)
        } else {
            cell.configureComicSearchResult(result: comicService.getSearchItems(index: indexPath.row))
        }
        return cell
    }
}
