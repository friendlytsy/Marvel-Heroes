//
//  UrlBuilder.swift
//  Marvel Heroes
//
//  Created by Alexander Tsygankov on 28.09.2021.
//

import Foundation

class UrlBuilder {
    
    func getUrl(_ urlPath: UrlPath, _ offset: Int) -> String {
        
        let cryptoHelper = CryptoHelper()

        //let apiKeyPublic = UserDefaults.standard.string(forKey: "restKey") ?? ""
        let apiKeyPublic = "6365e29ac17d2e2f2dc319a02fc0c26e"
        let apiKeyPrivate = "ecb3ab193999da9dd3431f0d2499dbe5023d1be2"
        
        let timestemp: String = String(format: "%f", Date().timeIntervalSince1970)
        let hash = cryptoHelper.getHash(ts: timestemp, apiKeyPrivate: apiKeyPrivate, apiKeyPublic: apiKeyPublic)
        
        var urlComponents = URLComponents()
        urlComponents.scheme = UrlSchema.https.rawValue
        urlComponents.host = UrlHost.marvelGateway.rawValue
        urlComponents.path = urlPath.rawValue
        urlComponents.queryItems = [
            URLQueryItem(name: "apikey", value: apiKeyPublic),
            URLQueryItem(name: "ts", value: timestemp),
            URLQueryItem(name: "hash", value: hash),
            URLQueryItem(name: "offset", value: String(offset)),
            URLQueryItem(name: "limit", value: "50")
        ]
        
        return urlComponents.url?.absoluteString ?? ""
    }
}
