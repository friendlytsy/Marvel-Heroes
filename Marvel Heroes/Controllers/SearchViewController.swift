//
//  SearchViewController.swift
//  Marvel Heroes
//
//  Created by Александр Цыганков on 07.11.2021.
//

import Foundation
import UIKit

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBAction func changedSegmentControl(_ sender: UISegmentedControl) {
    }
    
    let characterService = CharacterService()
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // - Configure segment control
        segmentControl.setTitle("Characters", forSegmentAt: 0)
        segmentControl.setTitle("Comics", forSegmentAt: 1)
        
        searchTableView.dataSource = self
        
        let nib = UINib(nibName: "GenericTableViewCell", bundle: nil)
        searchTableView.register(nib, forCellReuseIdentifier: "GenericTableViewCell")
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if (searchController.isActive && searchController.searchBar.text != "") {
//            return characterService.getSearchCount()
//        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GenericTableViewCell", for: indexPath) as! GenericTableViewCell
//        cell.configureSearchResult(result: UserDefaults.standard.object(forKey: "characterSearch") as! [Array<String>], with: indexPath.row)
        return cell
    }

    func updateSearchResults(for searchController: UISearchController) {
//        if (searchController.searchBar.text != "") {
//            characterService.searchCharacter(by: searchController.searchBar.text ?? "")
//            searchTableView.reloadData()
//        }
//    }
}
}
