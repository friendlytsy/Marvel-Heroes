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
        
    @IBOutlet weak var comicsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.comicDataModel = realm?.objects(ComicDataModel.self)
        comicsTableView.dataSource = self
        comicsTableView.delegate = self
        
        let nib = UINib(nibName: "GenericTableViewCell", bundle: nil)
        comicsTableView.register(nib, forCellReuseIdentifier: "GenericTableViewCell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comicDataModel?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = comicsTableView.dequeueReusableCell(withIdentifier: "GenericTableViewCell", for: indexPath) as! GenericTableViewCell
        cell.configureComic(withViewModel: (comicDataModel?[indexPath.row])!)
        return cell
    }
    
    
    // segue for comics. Will reuse view controller depenpd on description required to desplay
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "segueComics", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is ItemDescriptionViewController {
            let vc = segue.destination as? ItemDescriptionViewController
            vc?.itemName = (comicDataModel?[comicsTableView.indexPathForSelectedRow!.row].title)!   // Pass value of characterDataModel.characterName by selected row
            vc?.itemDescription = (comicDataModel?[comicsTableView.indexPathForSelectedRow!.row].comicDescription)! // Pass value of characterDataModel.characterDescription by selected row
            vc?.itemThumbnail = (comicDataModel?[comicsTableView.indexPathForSelectedRow!.row].thumbnail)! // Pass string of characterDataModel.thumbnail by selected row
            
            comicsTableView.deselectRow(at: comicsTableView.indexPathForSelectedRow!, animated: true)
        }
    }
}
