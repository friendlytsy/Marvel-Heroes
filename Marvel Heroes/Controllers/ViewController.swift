//
//  ViewController.swift
//  Marvel Heroes
//
//  Created by Александр Цыганков on 31.08.2021.
//

import UIKit
import RealmSwift
import SwiftUI

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let characterDataModel = CharacterDataModel()
        characterDataModel.updateData()

        let comicDataModel = ComicDataModel()
        comicDataModel.updateData()
    }
}

