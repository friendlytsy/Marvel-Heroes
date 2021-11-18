//
//  ComicsViewController.swift
//  Marvel Heroes
//
//  Created by Alexander Tsygankov on 14.09.2021.
//

import UIKit
import RealmSwift
import Firebase

class ComicsViewController: UIViewController, UITableViewDelegate, UISearchBarDelegate {
    
    var realm = try? Realm()
    var token: NotificationToken?
    var comicDataModel: Results<ComicDataModel>? = nil
    
    let comicService = ComicService()
    let comicSearchService = ComicSearchService()
    let comicFavoriteService = ComicFavoriteService()
    let searchController = UISearchController(searchResultsController: nil)

    @IBOutlet weak var comicsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.comicDataModel = realm?.objects(ComicDataModel.self)
        comicsTableView.dataSource = self
        comicsTableView.delegate = self
        
        // - Register GenericTableViewCell
        let nib = UINib(nibName: "GenericTableViewCell", bundle: nil)
        comicsTableView.register(nib, forCellReuseIdentifier: "GenericTableViewCell")
        
        comicService.updateData(0)
        observeRealm()
        
        // - Configure UISearch Controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Characters"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        searchController.searchBar.delegate = self
        comicsTableView.tableHeaderView = searchController.searchBar
        
        // - Analytics
        FirebaseAnalytics.Analytics.logEvent("comic_screen_viewed", parameters: [
            AnalyticsParameterScreenName: "comics-tab"])

    }
    
    // Favorite slider
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        var searchActive = false
        if (searchController.searchBar.text != "") {searchActive = true}
        
        let contextItem = UIContextualAction(style: .normal, title: "Favorite") { [self] (contextualAction, view, boolValue) in
            boolValue(true) // pass true if you want the handler to allow the action
            if (!(comicFavoriteService.makeFavorite(isSearch: searchActive, comicDataModel: comicDataModel!, index: indexPath.row)))
            {
                self.showAlert()
            }
        }
        contextItem.backgroundColor =  UIColor.systemBlue
        let swipeActions = UISwipeActionsConfiguration(actions: [contextItem])
        return swipeActions
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if ((indexPath.row == self.comicDataModel!.count - 1) && !DownloadManager.isDataLoading) {
            comicService.updateData(self.comicDataModel!.count)
        }
    }
    
    // segue for comics. Will reuse view controller depenpd on description required to desplay
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "segueComics", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is ItemDescriptionViewController {
            let vc = segue.destination as? ItemDescriptionViewController
            // - NEED TO RE DO HERE
            if (searchController.searchBar.text != "") {
                vc!.item = [String(comicSearchService.getSearchItems(index: comicsTableView.indexPathForSelectedRow!.row).title!),
                            String((comicSearchService.getSearchItems(index: comicsTableView.indexPathForSelectedRow!.row).description) ?? ""),
                            String((comicSearchService.getSearchItems(index: comicsTableView.indexPathForSelectedRow!.row).thumbnail?.url?.absoluteString)!)]
            } else {
                vc!.item = [String((comicDataModel?[comicsTableView.indexPathForSelectedRow!.row].title)!),
                            String((comicDataModel?[comicsTableView.indexPathForSelectedRow!.row].comicDescription) ?? ""),
                            String((comicDataModel?[comicsTableView.indexPathForSelectedRow!.row].thumbnail)!)]
            }
            comicsTableView.deselectRow(at: comicsTableView.indexPathForSelectedRow!, animated: true) // Deselect row
        }
    }
}
