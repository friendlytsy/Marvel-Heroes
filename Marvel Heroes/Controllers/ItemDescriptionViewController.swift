//
//  CharacterAboutViewController.swift
//  Marvel Heroes
//
//  Created by Alexander Tsygankov on 20.09.2021.
//

import UIKit
import Foundation
import Firebase

class ItemDescriptionViewController: UIViewController {
        
    let analyticsManager = AnalyticsManager()
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
        
        FirebaseAnalytics.Analytics.logEvent("detail_screen_viewed", parameters: [
            AnalyticsParameterScreenName: "item_detail_view",
            "item_name": item[0]
        ])
        
        }
}
