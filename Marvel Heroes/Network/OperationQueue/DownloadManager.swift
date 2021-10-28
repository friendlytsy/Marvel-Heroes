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
    
    func downloadData(urlPath: String, completion: @escaping(Data) -> Void) {
        let dataWrapper = DataWrapper()
        let operation = DownloadOperation(urlPath: urlPath, dataWrapper: dataWrapper)
        let finishOperation = BlockOperation {
          if let data = dataWrapper.data {
                completion(data)
            }
        }
        finishOperation.addDependency(operation)
        let operationQueue = OperationQueue()
        operationQueue.maxConcurrentOperationCount = 1
        operationQueue.addOperations([operation, finishOperation], waitUntilFinished: true)
    }
}
