//
//  CharacterViewController.swift
//  Marvel Heroes
//
//  Created by Alexander Tsygankov on 09.09.2021.
//

import UIKit

class CharacterViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
   
    @IBOutlet weak var characterTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        characterTableView.dataSource = self
        characterTableView.delegate = self
        // Do any additional setup after loading the view.
        
        let nib = UINib(nibName: "GenericTableViewCell", bundle: nil)
        characterTableView.register(nib, forCellReuseIdentifier: "GenericTableViewCell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 15
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = characterTableView.dequeueReusableCell(withIdentifier: "GenericTableViewCell", for: indexPath) as! GenericTableViewCell
        
        cell.lbItemName.text = "Character name"
        cell.lbItemDescription.text = "Very short description of character"
        cell.lbItemName.textColor = UIColor.blue
        cell.lbItemDescription.textAlignment = .center
        return cell
    }
    
    // segue for comics. Will reuse view controller depenpd on description required to desplay
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "segueCharacter", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is ItemDescriptionViewController {
            characterTableView.deselectRow(at: characterTableView.indexPathForSelectedRow!, animated: true)
        }
    }
}
