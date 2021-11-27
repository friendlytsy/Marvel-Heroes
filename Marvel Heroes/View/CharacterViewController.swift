//
//  CharacterViewController.swift
//  Marvel Heroes
//
//  Created by Alexander Tsygankov on 09.09.2021.
//

import UIKit
import RealmSwift
import FirebaseAnalytics

class CharacterViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate {
    
    var realm = try? Realm()
    var token: NotificationToken?
    var characterDataModel: Results<CharacterDataModel>? = nil

    var activityIndicator = UIActivityIndicatorView(style: .large)

    let characterService = CharacterService()
    let characterViewModel = CharacterViewModel()
    let searchController = UISearchController(searchResultsController: nil)

    @IBOutlet weak var characterTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.characterDataModel = realm?.objects(CharacterDataModel.self)
        
        characterTableView.dataSource = self
        characterTableView.delegate = self
        
        // - Register cell
        let nib = UINib(nibName: "GenericTableViewCell", bundle: nil)
        characterTableView.register(nib, forCellReuseIdentifier: "GenericTableViewCell")
        
        // - activityIndicator
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        activityIndicator.startAnimating()

        characterService.updateData(0){
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.characterTableView.reloadData()
            }
        }
        
        // - Configure UISearch Controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Characters"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        searchController.searchBar.delegate = self
        characterTableView.tableHeaderView = searchController.searchBar
        
        // - Analytics
        FirebaseAnalytics.Analytics.logEvent("character_screen_viewed", parameters: [
            AnalyticsParameterScreenName: "characters-tab"])
    }
    
    // Favorite slider
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        var searchActive = false
        if (searchController.searchBar.text != "") {searchActive = true}
        let contextItem = UIContextualAction(style: .normal, title: "Favorite") { [self] (contextualAction, view, boolValue) in
            boolValue(true) // pass true if you want the handler to allow the action
            if (!(characterViewModel.makeFavorite(isSearch: searchActive, characterDataModel: characterDataModel!, index: indexPath.row)))
            {
                self.showAlert()
            }
        }
        contextItem.backgroundColor =  UIColor.systemBlue
        let swipeActions = UISwipeActionsConfiguration(actions: [contextItem])
        return swipeActions
    }
    
    // Paging
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if ((indexPath.row == self.characterDataModel!.count - 1) && !DownloadManager.isDataLoading) {
            activityIndicator.startAnimating()
            characterService.updateData(self.characterDataModel!.count) {
                DispatchQueue.main.async {
                    self.characterTableView.reloadData()
                    self.activityIndicator.stopAnimating()
                }
            }
        }
    }
    
    // Segue for character. Will reuse view controller depenpd on description required to desplay
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "segueCharacter", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is ItemDescriptionViewController {
            let vc = segue.destination as? ItemDescriptionViewController
            if (searchController.searchBar.text != "") {
                vc!.item = characterService.prepareItemForSegue(for: nil, where: characterTableView.indexPathForSelectedRow!.row)
            } else {
                vc!.item = characterService.prepareItemForSegue(for: characterDataModel?[characterTableView.indexPathForSelectedRow!.row])
            }
            characterTableView.deselectRow(at: characterTableView.indexPathForSelectedRow!, animated: true)
        }
    }
}
