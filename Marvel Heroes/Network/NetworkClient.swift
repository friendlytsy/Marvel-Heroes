//
//  RequestData.swift
//  Marvel Heroes
//
//  Created by Александр Цыганков on 17.10.2021.
//

// DEPRICATED since HW4

import Foundation
import RealmSwift

class NetworkClient {
    
    func downloadTask(url: String, complition: @escaping (_ json: Any, _ data: Data) -> Void) {
        guard let url = URL(string: url) else { return print("ERROR") }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if error != nil || data == nil {
                print("Client error")
                return
            }
            
            guard let res = response as? HTTPURLResponse, (200...299).contains(res.statusCode) else {
                print("Server error!")
                return
            }
            
            let mi = res.mimeType
            guard let mime = res.mimeType, mime == "application/json" else {
                print("Wrong MIME type! \(String(describing: mi))")
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: [])
                complition(json, data!)
            } catch {
                print("JSON error: \(error.localizedDescription)")
            }
        }
        task.resume()
        
    }
}
