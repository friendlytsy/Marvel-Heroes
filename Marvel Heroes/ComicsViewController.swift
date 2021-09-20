//
//  ComicsViewController.swift
//  Marvel Heroes
//
//  Created by Alexander Tsygankov on 14.09.2021.
//

import UIKit

class ComicsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var comicsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        comicsTableView.dataSource = self
        comicsTableView.delegate = self
        
        let nib = UINib(nibName: "GenericTableViewCell", bundle: nil)
        comicsTableView.register(nib, forCellReuseIdentifier: "GenericTableViewCell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 15
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = comicsTableView.dequeueReusableCell(withIdentifier: "GenericTableViewCell", for: indexPath) as! GenericTableViewCell
        
        cell.lbItemName.text = "Comics name"
        cell.lbItemDescription.text = "Very short description of comics"
        cell.lbItemDescription.textAlignment = .center
        return cell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    // segue for comics. Will reuse view controller depenpd on description required to desplay
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "segueComics", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is ItemDescriptionViewController {
            comicsTableView.deselectRow(at: comicsTableView.indexPathForSelectedRow!, animated: true)
        }
    }

}
