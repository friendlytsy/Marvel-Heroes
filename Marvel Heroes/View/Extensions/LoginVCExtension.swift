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
        var status: Int? = nil
        let urlBuilder = UrlBuilder()
        // - Make this operation sync
        let semaphore = DispatchSemaphore(value: 0)
        // - Save value from text field
        UserDefaults.standard.set(self.loginInputField.text, forKey: "restKey")
        guard let url = URL(string: urlBuilder.getUrl(UrlPath.characteresListUrl, 0)) else { return print("ERROR") }
        DownloadManager.shared.verifyApiKey(urlPath: url.absoluteString){httpStatus in
            status = httpStatus
            semaphore.signal()
        }
        semaphore.wait()
        // - Remove "restKey" if status != 200
        if status != 200 {
            UserDefaults.standard.removeObject(forKey: "restKey")
            self.showAlert()
        }
    }
    
    func isSavedLogin() {
        if (UserDefaults.standard.string(forKey: "restKey") != nil) {
            loginInputField.text = UserDefaults.standard.string(forKey: "restKey")
        } else {
            loginInputField.placeholder = NSLocalizedString("apiFieldPlaceHolder", comment: "")
        }
    }
    
    func showAlert() {
        let alert = UIAlertController(title: NSLocalizedString("loginAlertTitle", comment: ""), message: NSLocalizedString("loginAlertMessage", comment: ""), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
}
