//
//  FavoritesViewController.swift
//  Marvel Heroes
//
//  Created by Александр Цыганков on 01.11.2021.
//

import Foundation
import UIKit

class FavoritesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet weak var favoritesTableView: UITableView!
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        let nib = UINib(nibName: "GenericTableViewCell", bundle: nil)
        favoritesTableView.register(nib, forCellReuseIdentifier: "GenericTableViewCell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = favoritesTableView.dequeueReusableCell(withIdentifier: "GenericTableViewCell", for: indexPath) as! GenericTableViewCell
        //cell.configureCharacter(withViewModel: (characterDataModel?[indexPath.row])!)
        return cell
    }
    
    
    

    
}
