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
    
    var characterDataModel: Results<CharacterDataModel>? = nil

    @IBOutlet weak var characterTableView: UITableView!
    
    //var characterDataModel = [CharacterModel]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.characterDataModel = realm?.objects(CharacterDataModel.self)
        
        characterTableView.dataSource = self
        characterTableView.delegate = self
        // Do any additional setup after loading the view.
        
        let nib = UINib(nibName: "GenericTableViewCell", bundle: nil)
        characterTableView.register(nib, forCellReuseIdentifier: "GenericTableViewCell")
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return characterDataModel!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = characterTableView.dequeueReusableCell(withIdentifier: "GenericTableViewCell", for: indexPath) as! GenericTableViewCell

        cell.configure(withViewModel: (characterDataModel?[indexPath.row])!)
        return cell
    }
    
    // segue for character. Will reuse view controller depenpd on description required to desplay
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "segueCharacter", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is ItemDescriptionViewController {
            let vc = segue.destination as? ItemDescriptionViewController
            vc?.itemName = (characterDataModel?[characterTableView.indexPathForSelectedRow!.row].name)!   // Pass value of characterDataModel.characterName by selected row
            vc?.itemDescription = (characterDataModel?[characterTableView.indexPathForSelectedRow!.row].charDescription)! // Pass value of characterDataModel.characterDescription by selected row
            vc?.itemThumbnail = (characterDataModel?[characterTableView.indexPathForSelectedRow!.row].thumbnail)! // Pass string of characterDataModel.thumbnail by selected row
            
            characterTableView.deselectRow(at: characterTableView.indexPathForSelectedRow!, animated: true) // Deselect row
        }
    }
}
