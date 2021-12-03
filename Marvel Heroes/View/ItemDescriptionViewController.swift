//
//  CharacterAboutViewController.swift
//  Marvel Heroes
//
//  Created by Alexander Tsygankov on 20.09.2021.
//

import UIKit
import Foundation

class ItemDescriptionViewController: UIViewController {
    
    var item = ["id":"", "name":"", "description":"","thumbnail":""]
    
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var itemDescriptionTextField: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let url = URL( string: item["thumbnail"] ?? "") {
            DispatchQueue.main.async { self.itemImage.kf.setImage(with: url, placeholder: UIImage(systemName: "paintbrush"))}
        }
        itemNameLabel.text = item["name"]
        if item["description"] == "" {
            itemDescriptionTextField.text = "Sorry, there is no description here :("
        } else {
            itemDescriptionTextField.text = item["description"]
        }
    }
}
