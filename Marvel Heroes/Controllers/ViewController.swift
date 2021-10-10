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
        let url = URL(string: urlBuilder.getUrl(UrlPath.characteresListUrl))
        let task = URLSession.shared.dataTask(with: url!, completionHandler: {(data, response, error) in
            if let error = error {
                print(error)
            }
            
            if let data = data{
                print("data =\(data)")
            }
            if let response = response {
                print("url = \(response.url!)")
                print("response = \(response)")
                let httpResponse = response as! HTTPURLResponse
                print("response code = \(httpResponse.statusCode)")
            }
            do{
                _ = try JSONSerialization.jsonObject(with: data!, options: [])
                //print(jsonObject)
                print("json parsing successful")
            }
            catch{
                print("json parsing field")
                //completion([], nil)
                print(error)
            }
            let decoder = JSONDecoder()
            do {
                let parsedData = try decoder.decode(CharacterDataWrapper.self, from: data!)
                print(parsedData)
            }
            catch {
                print(String(describing: error))
            }
        })
        task.resume()
    }
}

