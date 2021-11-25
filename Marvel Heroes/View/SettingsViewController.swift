//
//  SettingsViewController.swift
//  Marvel Heroes
//
//  Created by Александр Цыганков on 19.11.2021.
//

import Foundation
import UIKit

class SettingsViewController: UIViewController {
    
    @IBAction func crashApp(_ sender: Any) {
        fatalError("Test crash")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
