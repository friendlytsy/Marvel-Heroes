//
//  LoginVCExtension.swift
//  Marvel Heroes
//
//  Created by Александр Цыганков on 25.10.2021.
//

import Foundation
import SwiftUI

extension LoginViewController {
    func saveLogin() {
        if (loginInputField.text! != "") {
            UserDefaults.standard.set(loginInputField.text, forKey: "restKey")
        } else {
            showAlert()
        }
    }
    
    func isSavedLogin() {
        if (UserDefaults.standard.string(forKey: "restKey") != nil) {
            loginInputField.text = UserDefaults.standard.string(forKey: "restKey")
        } else {
            loginInputField.placeholder = "Please input your REST API here."
        }
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "API wasn't saved", message: "Something goes wrong, API will not be saved. Please try later", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
}
