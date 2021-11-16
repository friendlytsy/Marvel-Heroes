//
//  CharacterAboutViewController.swift
//  Marvel Heroes
//
//  Created by Alexander Tsygankov on 20.09.2021.
//

import UIKit
import Foundation

class ItemDescriptionViewController: UIViewController {
    
    var item: Character? = nil
    var itemArray: Array<String?> = []
    
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var itemDescriptionTextField: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if item != nil {
            if let url = URL( string: (item?.thumbnail?.url!.absoluteString)! ) {
                DispatchQueue.main.async {
                    self.itemImage.kf.setImage(with: url)
                }
            }
            
            itemNameLabel.text = item?.name ?? ""
            itemDescriptionTextField.text = item?.description ?? ""
        } else {
            if let url = URL( string: itemArray[2]! ) {
                DispatchQueue.main.async {
                    self.itemImage.kf.setImage(with: url)}
            }
            itemNameLabel.text = itemArray[0] ?? ""
            itemDescriptionTextField.text = itemArray[1] ?? ""
        }
    }
}
