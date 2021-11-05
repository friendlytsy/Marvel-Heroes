//
//  FavoritesViewController.swift
//  Marvel Heroes
//
//  Created by Александр Цыганков on 01.11.2021.
//

import Foundation
import UIKit
import RealmSwift

class FavoritesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    var realm = try? Realm()
    var token: NotificationToken?
    var favoriteItemDataModel: Results<FavoriteItemDataModel>? = nil
    
    @IBOutlet weak var favoritesTableView: UITableView!
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        self.favoriteItemDataModel = realm?.objects(FavoriteItemDataModel.self)
        
        favoritesTableView.dataSource = self
        favoritesTableView.delegate = self
        
        let nib = UINib(nibName: "GenericTableViewCell", bundle: nil)
        favoritesTableView.register(nib, forCellReuseIdentifier: "GenericTableViewCell")
        
        observeRealm()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteItemDataModel?.count ?? 0
    }
    
    // Favorite slider
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let contextItem = UIContextualAction(style: .normal, title: "Unfavorite") { [self] (contextualAction, view, boolValue) in
            boolValue(true) // pass true if you want the handler to allow the action
            FavoriteItemDataModel.makeUnfavorite(favoriteItemDataModel: favoriteItemDataModel![indexPath.row])
        }
        contextItem.backgroundColor =  UIColor.systemRed
        let swipeActions = UISwipeActionsConfiguration(actions: [contextItem])
        
        return swipeActions
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = favoritesTableView.dequeueReusableCell(withIdentifier: "GenericTableViewCell", for: indexPath) as! GenericTableViewCell
        cell.configureFavorite(withViewModel: (favoriteItemDataModel?[indexPath.row])!)
        return cell
    }
    
    // segue for character. Will reuse view controller depenpd on description required to desplay
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "segueFavorites", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is ItemDescriptionViewController {
            let vc = segue.destination as? ItemDescriptionViewController
            vc?.itemName = (favoriteItemDataModel?[favoritesTableView.indexPathForSelectedRow!.row].itemTitle)!   // Pass value of characterDataModel.characterName by selected row
            vc?.itemDescription = (favoriteItemDataModel?[favoritesTableView.indexPathForSelectedRow!.row].itemDescription)! // Pass value of characterDataModel.characterDescription by selected row
            vc?.itemThumbnail = (favoriteItemDataModel?[favoritesTableView.indexPathForSelectedRow!.row].itemThumbnail)! // Pass string of characterDataModel.thumbnail by selected row
            
            favoritesTableView.deselectRow(at: favoritesTableView.indexPathForSelectedRow!, animated: true) // Deselect row
        }
    }
}
