//
//  DownloadOperation.swift
//  Marvel Heroes
//
//  Created by Александр Цыганков on 27.10.2021.
//

import Foundation

class DownloadOperation : Operation {
    
    var requestStatus: Int? = nil
    var operationResult: Data? = nil
    var urlPath: String = ""
    private var dataTask: URLSessionDataTask?
    var urlSession: URLSession
    
    init(urlSession: URLSession, urlPath: String) {
        self.urlSession = urlSession
        self.urlPath = urlPath
        super.init()
        print("init\(self)")
    }
    
    deinit {
        print("deinit\(self)")
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
                self.requestStatus = httpResponse.statusCode
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
