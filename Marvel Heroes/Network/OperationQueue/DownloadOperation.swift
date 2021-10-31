//
//  DownloadOperation.swift
//  Marvel Heroes
//
//  Created by Александр Цыганков on 27.10.2021.
//

import Foundation
import SwiftUI

class DownloadOperation : Operation {

//    lazy var urlSession: URLSession = {
//        return URLSession(configuration: .default)
//    }()
    
    var operationResult: Data? = nil
    var urlPath: String = ""
    private var dataTask: URLSessionDataTask?
    var urlSession: URLSession
    
    init(urlSession: URLSession, urlPath: String) {
        self.urlSession = urlSession
        self.urlPath = urlPath
    }
    
    override func main() {
        let semaphore = DispatchSemaphore(value: 0)
        guard let url = URL(string: self.urlPath) else {return self.urlPath = ""}
        let urlRequest = URLRequest(url: url)
        dataTask = urlSession.dataTask(with: urlRequest, completionHandler: { data, response, error in
            if let error = error {
                print(error.localizedDescription)
            }
            if let httpResponse = response as? HTTPURLResponse{
                if httpResponse.statusCode == 200{
                    self.operationResult = data
                }
            }
            semaphore.signal()
        })
        self.dataTask?.resume()
        semaphore.wait()
    }
    
    override func cancel() {
        super.cancel()
    }
}
