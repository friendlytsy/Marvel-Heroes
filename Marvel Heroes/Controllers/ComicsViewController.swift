//
//  ComicsViewController.swift
//  Marvel Heroes
//
//  Created by Alexander Tsygankov on 14.09.2021.
//

import UIKit
import RealmSwift

class ComicsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var realm = try? Realm()
    var token: NotificationToken?
    var comicDataModel: Results<ComicDataModel>? = nil
    var favoriteComicDataModel: Results<FavoriteComicDataModel>? = nil
    
    @IBOutlet weak var comicSegmentControl: UISegmentedControl!
    @IBOutlet weak var comicsTableView: UITableView!
    @IBAction func onChangeSegment(_ sender: UISegmentedControl) {
        comicsTableView.reloadData()
        observeRealm()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        comicSegmentControl.setTitle("Catalog", forSegmentAt: 0)
        comicSegmentControl.setTitle("Favorite", forSegmentAt: 1)
        
        self.comicDataModel = realm?.objects(ComicDataModel.self)
        self.favoriteComicDataModel = realm?.objects(FavoriteComicDataModel.self)
        comicsTableView.dataSource = self
        comicsTableView.delegate = self
        
        let nib = UINib(nibName: "GenericTableViewCell", bundle: nil)
        comicsTableView.register(nib, forCellReuseIdentifier: "GenericTableViewCell")
        
        ComicDataModel.updateData(UrlBuilder.offset)
        observeRealm()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let indexSelected = self.comicSegmentControl.selectedSegmentIndex
        switch indexSelected {
        case 0:
            return comicDataModel?.count ?? 0
        case 1:
            return favoriteComicDataModel?.count ?? 0
        default:
            return 0
        }
    }
    
    // Favorite slider
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let indexSelected = self.comicSegmentControl.selectedSegmentIndex
        switch indexSelected
        {
        case 0:
            let contextItem = UIContextualAction(style: .normal, title: "Favorite") { [self] (contextualAction, view, boolValue) in
                boolValue(true) // pass true if you want the handler to allow the action
                if (!FavoriteComicDataModel.makeFavorite(comicDataModel: comicDataModel![indexPath.row])) {
                    self.showAlert()
                }
            }
            contextItem.backgroundColor =  UIColor.systemBlue
            let swipeActions = UISwipeActionsConfiguration(actions: [contextItem])
            return swipeActions
            
        case 1:
            let contextItem = UIContextualAction(style: .normal, title: "Unfavorite") { [self] (contextualAction, view, boolValue) in
                boolValue(true) // pass true if you want the handler to allow the action
                FavoriteComicDataModel.makeUnfavorite(favoriteComicDataModel: favoriteComicDataModel![indexPath.row])
                observeRealm()
            }
            contextItem.backgroundColor =  UIColor.systemRed
            let swipeActions = UISwipeActionsConfiguration(actions: [contextItem])
            return swipeActions
            
        default:
            return UISwipeActionsConfiguration()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let indexSelected = self.comicSegmentControl.selectedSegmentIndex
        switch indexSelected {
        case 0:
            let cell = comicsTableView.dequeueReusableCell(withIdentifier: "GenericTableViewCell", for: indexPath) as! GenericTableViewCell
            cell.configureComic(withViewModel: (comicDataModel?[indexPath.row])!)
            return cell
        case 1:
            let cell = comicsTableView.dequeueReusableCell(withIdentifier: "GenericTableViewCell", for: indexPath) as! GenericTableViewCell
            cell.configureComicFavorite(withViewModel: (favoriteComicDataModel?[indexPath.row])!)
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if ((indexPath.row == self.comicDataModel!.count - 1) && !DownloadManager.isDataLoading) {
            ComicDataModel.updateData(String(self.comicDataModel!.count))
        }
    }
    
    // segue for comics. Will reuse view controller depenpd on description required to desplay
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "segueComics", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is ItemDescriptionViewController {
            let vc = segue.destination as? ItemDescriptionViewController
            
            let indexSelected = self.comicSegmentControl.selectedSegmentIndex
            switch indexSelected {
            case 0:
                vc?.itemName = (comicDataModel?[comicsTableView.indexPathForSelectedRow!.row].title)!   // Pass value of characterDataModel.characterName by selected row
                vc?.itemDescription = (comicDataModel?[comicsTableView.indexPathForSelectedRow!.row].comicDescription) ?? "" // Pass value of characterDataModel.characterDescription by selected row
                vc?.itemThumbnail = (comicDataModel?[comicsTableView.indexPathForSelectedRow!.row].thumbnail)! // Pass string of characterDataModel.thumbnail by selected row
            case 1:
                vc?.itemName = (favoriteComicDataModel?[comicsTableView.indexPathForSelectedRow!.row].itemTitle)!   // Pass value of characterDataModel.characterName by selected row
                vc?.itemDescription = (favoriteComicDataModel?[comicsTableView.indexPathForSelectedRow!.row].itemDescription) ?? "" // Pass value of characterDataModel.characterDescription by selected row
                vc?.itemThumbnail = (favoriteComicDataModel?[comicsTableView.indexPathForSelectedRow!.row].itemThumbnail)! // Pass string of characterDataModel.thumbnail by selected row
            default:
                break
            }
            comicsTableView.deselectRow(at: comicsTableView.indexPathForSelectedRow!, animated: true)
        }
    }
}
