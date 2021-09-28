//
//  ViewController.swift
//  Marvel Heroes
//
//  Created by Александр Цыганков on 31.08.2021.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
                
        let urlBuilder = UrlBuilder()
        let url = URL(string: urlBuilder.getUrl(UrlPath.characteresUrl.rawValue))
        let task = URLSession.shared.dataTask(with: url!) {(data, response, error) in
            guard let data = data else { return }
            print(String(data: data, encoding: .utf8)!)
        }
        task.resume()

    }
}

