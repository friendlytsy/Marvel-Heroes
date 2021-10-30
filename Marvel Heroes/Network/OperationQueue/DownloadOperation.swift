//
//  DownloadOperation.swift
//  Marvel Heroes
//
//  Created by Александр Цыганков on 27.10.2021.
//

import Foundation
import SwiftUI

class DownloadOperation : Operation {
    
    private weak var dataWrapper: DataWrapper? = nil
    
    lazy var urlSession: URLSession = {
        return URLSession(configuration: .default)
    }()
    
    var urlPath: String = ""
    var data: Data? = nil
    var dataTask: URLSessionDataTask?
    
    init(urlPath: String, dataWrapper: DataWrapper) {
        self.urlPath = urlPath
        self.dataWrapper = dataWrapper
    }
    
    override func main() {
        let semaphore = DispatchSemaphore(value: 0)
        let urlSessionTaskWrapper = DispatchQueue(label: "urlSessionTaskWrapper")
        urlSessionTaskWrapper.async {
            self.dataTask?.cancel()
            guard let url = URL(string: self.urlPath) else {return self.urlPath = ""}
            let urlRequest = URLRequest(url: url)
            self.dataTask = self.urlSession.dataTask(with: urlRequest, completionHandler: { data, response, error in
                if let error = error {
                    print(error.localizedDescription)
                }
                if let httpResponse = response as? HTTPURLResponse{
                    if httpResponse.statusCode == 200{
                        self.dataWrapper?.data = data
                    }
                }
                semaphore.signal()
            })
            self.dataTask?.resume()
        }
        semaphore.wait()
    }
}
