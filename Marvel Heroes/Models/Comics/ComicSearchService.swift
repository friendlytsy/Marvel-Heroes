//
//  ComicSearchService.swift
//  Marvel Heroes
//
//  Created by Александр Цыганков on 16.11.2021.
//

import Foundation

class ComicSearchService {
    
    func searchComic(by name: String) {
        // Access Shared Defaults Object
        let userDefaults = UserDefaults.standard
        let urlBuilder = UrlBuilder()
        guard let url = URL(string: urlBuilder.getUrl(UrlPath.comicsListUrl, 0, queryComic: name)) else { return print("ERROR") }
        var comics: [Comic] = []
        let semaphore = DispatchSemaphore(value: 0)
        DownloadManager.shared.downloadData(urlPath: url.absoluteString) { data in
            do {
                let decoder = JSONDecoder()
                let getData = try decoder.decode(ComicDataWrapper.self, from: data)
                // - Decode from JSON to array of struct
                try getData.data?.results?.forEach{item in
                    comics.append(item)
                }
                
                // - Encode to save at UserDefaults
                let encoder = JSONEncoder()
                do {
                    let encodedCharacters = try encoder.encode(comics)
                    userDefaults.set(encodedCharacters, forKey: "comicSearch")
                }
                semaphore.signal()
            }
            catch {
                print(error.localizedDescription)
            }
        }
        semaphore.wait()
    }
    
    func getSearchCount() -> Int {
        if let items = UserDefaults.standard.data(forKey: "comicSearch") {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode([Comic].self, from: items) {
                return decoded.count
            }
        }
        return 0
    }
    
    func getSearchItems(index: Int) -> Comic {
        let items = UserDefaults.standard.data(forKey: "comicSearch")!
        let decoder = JSONDecoder()
        let decoded = try? decoder.decode([Comic].self, from: items)
        
        return decoded![index]
    }
}
