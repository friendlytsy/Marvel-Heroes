//
//  ViewController.swift
//  Marvel Heroes
//
//  Created by Александр Цыганков on 31.08.2021.
//

import UIKit
import RealmSwift
import SwiftUI

class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginInputField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBAction func doLogonButton(_ sender: UIButton) {
        self.saveLogin()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.isSavedLogin()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
