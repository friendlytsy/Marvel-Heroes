//
//  DataService.swift
//  Marvel Heroes
//
//  Created by Александр Цыганков on 16.11.2021.
//

import Foundation

class CharacterSearchService {
    
    func searchCharacter(by name: String, onComplete: @escaping() -> Void) {
        // Access Shared Defaults Object
        let userDefaults = UserDefaults.standard
        let urlBuilder = UrlBuilder()
        guard let url = URL(string: urlBuilder.getUrl(UrlPath.characteresListUrl, 0, queryCharacter: name)) else { return print("ERROR") }
        var characters: [Character] = []
        DownloadManager.shared.downloadData(urlPath: url.absoluteString) { data in
            do {
                let decoder = JSONDecoder()
                let getData = try decoder.decode(CharacterDataWrapper.self, from: data)
                // - Decode from JSON to array of struct
                try getData.data?.results?.forEach{item in
                    characters.append(item)
                }
                // - Encode to save at UserDefaults
                let encoder = JSONEncoder()
                do {
                    let encodedCharacters = try encoder.encode(characters)
                    userDefaults.set(encodedCharacters, forKey: "characterSearch")
                }
            }
            catch {
                print(error.localizedDescription)
            }
            onComplete()
        }
    }
    
    func getSearchCount() -> Int {
        if let items = UserDefaults.standard.data(forKey: "characterSearch") {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode([Character].self, from: items) {
                return decoded.count
            }
        }
        return 0
    }
    
    func getSearchItems(index: Int) -> Character {
        let items = UserDefaults.standard.data(forKey: "characterSearch")!
        let decoder = JSONDecoder()
        let decoded = try? decoder.decode([Character].self, from: items)
        
        return decoded![index]
    }
}
