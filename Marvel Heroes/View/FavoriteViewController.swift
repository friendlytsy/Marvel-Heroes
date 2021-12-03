//
//  SearchViewController.swift
//  Marvel Heroes
//
//  Created by Александр Цыганков on 07.11.2021.
//

import Foundation
import UIKit

class FavoriteViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let characterViewModel = CharacterViewModel()
    let comicViewModel = ComicViewModel()
    
    @IBOutlet weak var favoriteTableView: UITableView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBAction func changedSegmentControl(_ sender: UISegmentedControl) {
        favoriteTableView.reloadData()
    }
    
    let characterService = CharacterService()
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // - Configure segment control
        segmentControl.setTitle("Characters", forSegmentAt: 0)
        segmentControl.setTitle("Comics", forSegmentAt: 1)
        
        favoriteTableView.dataSource = self
        favoriteTableView.delegate = self
        
        // - Register custom cell
        let nib = UINib(nibName: "GenericTableViewCell", bundle: nil)
        favoriteTableView.register(nib, forCellReuseIdentifier: "GenericTableViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        favoriteTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch (segmentControl.selectedSegmentIndex){
        case 0:
            return characterViewModel.getFavoriteCount(of: "characterFavorites")
        case 1:
            return comicViewModel.getFavoriteCount(of: "comicFavorites")
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GenericTableViewCell", for: indexPath) as! GenericTableViewCell
        switch (segmentControl.selectedSegmentIndex){
        case 0:
            cell.configureCharacter(withViewModel: characterViewModel.getFavorite(with: indexPath.row))
        case 1:
            cell.configureComic(withViewModel: comicViewModel.getFavorite(with: indexPath.row))
        default:
            return UITableViewCell()
        }
        return cell
    }
    
    // Favorite slider
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        var key = ""
        switch (segmentControl.selectedSegmentIndex){
        case 0:
            key = "characterFavorites"
        case 1:
            key = "comicFavorites"
        default:
            break
        }
        let contextItem = UIContextualAction(style: .normal, title: "Unfavorite") { [self] (contextualAction, view, boolValue) in
            boolValue(true) // pass true if you want the handler to allow the action
            characterViewModel.makeUnfavorite(forkey: key, index: indexPath.row)
            favoriteTableView.deleteRows(at: [indexPath], with: .fade)

        }
        contextItem.backgroundColor =  UIColor.systemRed
        let swipeActions = UISwipeActionsConfiguration(actions: [contextItem])
        return swipeActions
    }
    
    // Segue for character. Will reuse view controller depenpd on description required to desplay
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "details", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is ItemDescriptionViewController {
            let vc = segue.destination as? ItemDescriptionViewController
            switch (segmentControl.selectedSegmentIndex){
            case 0:
                vc!.item = characterViewModel.prepareItemForSegue(where: favoriteTableView.indexPathForSelectedRow!.row)
            case 1:
                vc!.item = comicViewModel.prepareItemForSegue(where: favoriteTableView.indexPathForSelectedRow!.row)
            default:
                break
            }
            favoriteTableView.deselectRow(at: favoriteTableView.indexPathForSelectedRow!, animated: true)
        }
    }
}

