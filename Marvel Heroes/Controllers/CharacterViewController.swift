//
//  CharacterViewController.swift
//  Marvel Heroes
//
//  Created by Alexander Tsygankov on 09.09.2021.
//

import UIKit

class CharacterViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
   
    @IBOutlet weak var characterTableView: UITableView!
    
    var characterDataModel = [CharacterModel]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        // Adding character to characterDataModel
        characterDataModel.append(CharacterModel(UIImage(named: "marvel_logo")!, "Spider-Man", "Super-human levels of strength, speed, agility, stamina, durability and reflexes"))
        characterDataModel.append(CharacterModel(UIImage(named: "marvel_logo")!, "Iron-Man", "Genius level intellect Proficient scientist and engineer Powered armor suit"))
        characterDataModel.append(CharacterModel(UIImage(named: "marvel_logo")!, "Black Panther", "Genius-level intellect. Highly proficient tactician, strategist and inventor."))
        characterDataModel.append(CharacterModel(UIImage(named: "marvel_logo")!, "DeadPool", "Regeneration/Healing Factor Extended longevity Skilled marksman, swordsman, martial artist"))
        characterDataModel.append(CharacterModel(UIImage(named: "marvel_logo")!, "Captain America", "Super-human levels of strength, speed, agility, stamina, durability and reflexes;"))
        characterDataModel.append(CharacterModel(UIImage(named: "marvel_logo")!, "Jessica Jones", "Superhuman strength and durability Flight Skilled hand-to-hand combatant Expert detective"))
        characterDataModel.append(CharacterModel(UIImage(named: "marvel_logo")!, "Ant-Man", "Ability to shrink to sub-microscopic size and enter the subatomic universes. Genius-level intellect."))
        characterDataModel.append(CharacterModel(UIImage(named: "marvel_logo")!, "Captain Marvel", "Super-human levels stamina, Energy manipulation, absorption, and projection Flight"))
        characterDataModel.append(CharacterModel(UIImage(named: "marvel_logo")!, "Guardians of the Galaxy", "Super-human levels of strength, speed, agility, stamina, durability and reflexes"))
        characterDataModel.append(CharacterModel(UIImage(named: "marvel_logo")!, "Wolvarine", "Superhuman senses and animal-like attributes."))
        characterDataModel.append(CharacterModel(UIImage(named: "marvel_logo")!, "Luke Cage", "Superhuman strength and durability Unbreakable skin Skilled street fighter"))
        characterDataModel.append(CharacterModel(UIImage(named: "marvel_logo")!, "Bishop", "Energy absorption and redirection Superhuman physical attributes Ability to instinctively know present location"))
        characterDataModel.append(CharacterModel(UIImage(named: "marvel_logo")!, "Chimera", "Can generate ectoplasmic bursts in the form of telekinetic dragons"))
        characterDataModel.append(CharacterModel(UIImage(named: "marvel_logo")!, "Echo", "Olympic-level athlete Concert-level pianist Strong martial artist"))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        characterTableView.dataSource = self
        characterTableView.delegate = self
        // Do any additional setup after loading the view.
        
        let nib = UINib(nibName: "GenericTableViewCell", bundle: nil)
        characterTableView.register(nib, forCellReuseIdentifier: "GenericTableViewCell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return characterDataModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = characterTableView.dequeueReusableCell(withIdentifier: "GenericTableViewCell", for: indexPath) as! GenericTableViewCell

        cell.configure(withViewModel: characterDataModel[indexPath.row])
        return cell
    }
    
    // segue for character. Will reuse view controller depenpd on description required to desplay
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "segueCharacter", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is ItemDescriptionViewController {
            let vc = segue.destination as? ItemDescriptionViewController
            vc?.itemName = characterDataModel[characterTableView.indexPathForSelectedRow!.row].characterName   // Pass value of characterDataModel.characterName by selected row
            vc?.itemDescription = characterDataModel[characterTableView.indexPathForSelectedRow!.row].characterDescription // Pass value of characterDataModel.characterDescription by selected row
            characterTableView.deselectRow(at: characterTableView.indexPathForSelectedRow!, animated: true) // Deselect row
        }
    }
}
