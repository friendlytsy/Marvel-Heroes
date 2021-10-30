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

    func downloadData(urlPath: String, completion: @escaping(Data) -> Void) {
        let dataWrapper = DataWrapper()
        let operation = DownloadOperation(urlPath: urlPath, dataWrapper: dataWrapper)
        operation.completionBlock = {
            if dataWrapper.data != nil {
                  completion(dataWrapper.data!)
              }
        }
        DownloadManager.operationQueue.addOperations([operation], waitUntilFinished: false)
    }
}

