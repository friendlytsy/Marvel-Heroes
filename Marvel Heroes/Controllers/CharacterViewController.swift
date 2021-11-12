//
//  CharacterViewController.swift
//  Marvel Heroes
//
//  Created by Alexander Tsygankov on 09.09.2021.
//

import UIKit
import RealmSwift

class CharacterViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var realm = try? Realm()
    var token: NotificationToken?
    var characterDataModel: Results<CharacterDataModel>? = nil
    
    let characterService = CharacterService()
    
    @IBOutlet weak var characterTableView: UITableView!
    @IBOutlet weak var characterSegmentControl: UISegmentedControl!
    @IBAction func onChangeSegment(_ sender: UISegmentedControl) {
        characterTableView.reloadData()
        observeRealm()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        characterSegmentControl.setTitle("Catalog", forSegmentAt: 0)
        characterSegmentControl.setTitle("Favorite", forSegmentAt: 1)
        
        self.characterDataModel = realm?.objects(CharacterDataModel.self)
        
        characterTableView.dataSource = self
        characterTableView.delegate = self
        
        let nib = UINib(nibName: "GenericTableViewCell", bundle: nil)
        characterTableView.register(nib, forCellReuseIdentifier: "GenericTableViewCell")
        
        characterService.updateData(0)
        observeRealm()
    }
    
    // Favorite slider
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let indexSelected = self.characterSegmentControl.selectedSegmentIndex
        switch indexSelected
        {
        case 0:
            let contextItem = UIContextualAction(style: .normal, title: "Favorite") { [self] (contextualAction, view, boolValue) in
                boolValue(true) // pass true if you want the handler to allow the action
                if (!(characterService.makeFavorite(characterDataModel: characterDataModel![indexPath.row])))
                {
                    self.showAlert()
                }
            }
            contextItem.backgroundColor =  UIColor.systemBlue
            let swipeActions = UISwipeActionsConfiguration(actions: [contextItem])
            return swipeActions
            
        case 1:
            let contextItem = UIContextualAction(style: .normal, title: "Unfavorite") { [self] (contextualAction, view, boolValue) in
                boolValue(true) // pass true if you want the handler to allow the action
                if(characterService.makeUnfavorite(characterDataModel: characterService.getFavorite(with: indexPath.row))) {
                    observeRealm()
                }
            }
            contextItem.backgroundColor =  UIColor.systemRed
            let swipeActions = UISwipeActionsConfiguration(actions: [contextItem])
            return swipeActions
            
        default:
            return UISwipeActionsConfiguration()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let indexSelected = self.characterSegmentControl.selectedSegmentIndex
        switch indexSelected {
        case 0:
            return characterDataModel?.count ?? 0
        case 1:
            return characterService.getCharacterFavoriteCount()
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let indexSelected = self.characterSegmentControl.selectedSegmentIndex
        switch indexSelected {
        case 0:
            let cell = characterTableView.dequeueReusableCell(withIdentifier: "GenericTableViewCell", for: indexPath) as! GenericTableViewCell
            cell.configureCharacter(withViewModel: (characterDataModel?[indexPath.row])!)
            return cell
        case 1:
            let cell = characterTableView.dequeueReusableCell(withIdentifier: "GenericTableViewCell", for: indexPath) as! GenericTableViewCell
            cell.configureCharacter(withViewModel: (characterService.getFavorite(with: indexPath.row)))
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    // Paging
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if ((indexPath.row == self.characterDataModel!.count - 1) && !DownloadManager.isDataLoading) {
            characterService.updateData(self.characterDataModel!.count)
        }
    }
    
    // Segue for character. Will reuse view controller depenpd on description required to desplay
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "segueCharacter", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is ItemDescriptionViewController {
            let vc = segue.destination as? ItemDescriptionViewController
            let indexSelected = self.characterSegmentControl.selectedSegmentIndex
            switch indexSelected {
            case 0:
                vc!.item = characterService.passCharacterItem(from: (characterDataModel?[characterTableView.indexPathForSelectedRow!.row])!)
            case 1:
                vc!.item = characterService.passCharacterItem(from: (characterService.getFavorite(with: characterTableView.indexPathForSelectedRow!.row)))
            default:
                break
            }
            
            characterTableView.deselectRow(at: characterTableView.indexPathForSelectedRow!, animated: true) // Deselect row
        }
    }
}
