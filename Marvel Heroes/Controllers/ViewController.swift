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
        
        let cryptoHelper = CryptoHelper()
        
        let apiKeyPublic = "6365e29ac17d2e2f2dc319a02fc0c26e"
        let apiKeyPrivate = "ecb3ab193999da9dd3431f0d2499dbe5023d1be2"

        let ts: String = String(format: "%f", Date().timeIntervalSince1970)
        let hash = cryptoHelper.getHash(ts: ts, apiKeyPrivate: apiKeyPrivate, apiKeyPublic: apiKeyPublic)

        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "gateway.marvel.com"
        urlComponents.path = "/v1/public/characters"
        urlComponents.queryItems = [
            URLQueryItem(name: "apikey", value: apiKeyPublic),
            URLQueryItem(name: "ts", value: ts),
            URLQueryItem(name: "hash", value: hash)
           
        ]

        print(urlComponents.url?.absoluteString as Any)

        let url = URL(string: urlComponents.url?.absoluteString ?? "")!

        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data else { return }
            print(String(data: data, encoding: .utf8)!)
        }
        task.resume()
        
    }


}

