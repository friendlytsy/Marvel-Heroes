//
//  CharacterAboutViewController.swift
//  Marvel Heroes
//
//  Created by Alexander Tsygankov on 20.09.2021.
//

import UIKit
import Foundation

class ItemDescriptionViewController: UIViewController {
    
    var item: Array<String> = Array()
    
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var itemDescriptionTextField: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
            if let url = URL( string: item[2]) {
                DispatchQueue.main.async { self.itemImage.kf.setImage(with: url)}
            }
            itemNameLabel.text = item[0]
            itemDescriptionTextField.text = item[1]
        }
}
