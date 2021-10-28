//
//  DownloadOperation.swift
//  Marvel Heroes
//
//  Created by Александр Цыганков on 27.10.2021.
//

import Foundation

class DataWrapper {
    var data: Data? = nil
    init() {}
    init(data: Data?) {
        self.data = data
    }
}

class DownloadOperation : AsyncOperation {

    private weak var dataWrapper: DataWrapper? = nil
    
    lazy var urlSession: URLSession = {
        return URLSession(configuration: .default)
    }()
    
    var urlPath: String = ""
    var dataResult: Data? = nil
    var dataTask: URLSessionDataTask?
    
    override init() {
        super.init()
    }
    
    convenience init(urlPath: String, dataWrapper: DataWrapper) {
        self.init()
        self.urlPath = urlPath
        self.dataWrapper = dataWrapper
    }
    
    override func main() {
        self.dataTask?.cancel()
        guard let url = URL(string: urlPath) else {return}
        let urlRequest = URLRequest(url: url)
        self.dataTask = urlSession.dataTask(with: urlRequest, completionHandler: { data, response, error in
            if let data = data {
                self.dataResult = data
                self.dataWrapper?.data = data
                print(data)
            }
            self.state = .finished
            
            if let error = error {
                print("JSON error: \(error.localizedDescription)")
            }
        })
        dataTask?.resume()
    }
}
