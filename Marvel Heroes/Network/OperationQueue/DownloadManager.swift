//
//  DownloadManager.swift
//  Marvel Heroes
//
//  Created by Александр Цыганков on 27.10.2021.
//

import Foundation
import UIKit

class DownloadManager {
    static let shared = DownloadManager()
    static private let operationQueue = OperationQueue()
    private let urlSession: URLSession = {
        return URLSession(configuration: .default)
    }()
    
    func downloadData(urlPath: String, completion: @escaping(Data) -> Void) {
        let operation = DownloadOperation(urlSession: urlSession, urlPath: urlPath)
        operation.completionBlock = {
            completion(operation.operationResult!)
        }
        DownloadManager.operationQueue.addOperations([operation], waitUntilFinished: false)
    }
}

