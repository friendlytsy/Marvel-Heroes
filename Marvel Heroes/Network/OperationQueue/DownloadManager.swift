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
    static var isDataLoading: Bool = false
    private let urlSession: URLSession = {
        return URLSession(configuration: .default)
    }()
    
    func downloadData(urlPath: String, completion: @escaping(Data) -> Void) {
        DownloadManager.isDataLoading = true
        let operation = DownloadOperation(urlSession: urlSession, urlPath: urlPath)
        operation.completionBlock = {
            completion(operation.operationResult!)
            DownloadManager.isDataLoading = false
        }
        DownloadManager.operationQueue.addOperations([operation], waitUntilFinished: false)
    }
    
    func verifyApiKey(urlPath: String, completion: @escaping(Int) -> Void) {
        let operation = DownloadOperation(urlSession: urlSession, urlPath: urlPath)
        operation.completionBlock = {
            completion(operation.requestStatus!)
        }
        DownloadManager.operationQueue.addOperations([operation], waitUntilFinished: false)
    }
}

