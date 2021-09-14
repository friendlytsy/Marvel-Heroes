//
//  CharacterViewController.swift
//  Marvel Heroes
//
//  Created by Alexander Tsygankov on 09.09.2021.
//

import UIKit

class CharacterViewController: UIViewController, UITableViewDataSource {
   
    @IBOutlet weak var characterTablewView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        characterTablewView.dataSource = self
        // Do any additional setup after loading the view.
        
        let nib = UINib(nibName: "GenericTableViewCell", bundle: nil)
        characterTablewView.register(nib, forCellReuseIdentifier: "GenericTableViewCell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 15
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = characterTablewView.dequeueReusableCell(withIdentifier: "GenericTableViewCell", for: indexPath) as! GenericTableViewCell
        
        cell.lbItemName.text = "Character name"
        cell.lbItemDescription.text = "Very short description of character"
        cell.lbItemName.textColor = UIColor.blue
        cell.lbItemDescription.textAlignment = .center
        return cell
    }

}
