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
    func showAlert() {
        let alert = UIAlertController(title: NSLocalizedString("comicAlertTitle", comment: ""), message: NSLocalizedString("comicAlertMessage", comment: ""), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
}

extension ComicsViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {}
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        activityIndicator.startAnimating()
        comicService.searchComic(by: searchController.searchBar.text ?? "") {
            DispatchQueue.main.async {
                self.comicsTableView.reloadData()
                self.activityIndicator.stopAnimating()
            }
        }
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        activityIndicator.startAnimating()
        comicService.updateData(0){
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.comicsTableView.reloadData()
            }
        }
        comicViewModel.cleanupSearch()
    }
}

extension ComicsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return comicViewModel.getSearchCount(of: "comicSearch")
        }
        return comicDataModel?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = comicsTableView.dequeueReusableCell(withIdentifier: "GenericTableViewCell", for: indexPath) as! GenericTableViewCell
        if !searchController.isActive {
            cell.configureComic(withViewModel: (comicDataModel?[indexPath.row])!)
        } else {
            cell.configureComic(withViewModel: comicViewModel.getSearchItem(index: indexPath.row))
        }
        return cell
    }
}
