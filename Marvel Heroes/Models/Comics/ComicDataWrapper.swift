//
//  ComicDataWrapper.swift
//  Marvel Heroes
//
//  Created by Александр Цыганков on 10.10.2021.
//

import Foundation
import RealmSwift

class ComicDataWrapper: Object, Decodable {
    @Persisted var code: Int?
    @Persisted var status: String?
    @Persisted var copyright: String?
    @Persisted var attributionText: String?
    @Persisted var attributionHTML: String?
    var comicDataContainer: ComicDataContainer?
    
    dynamic var etag: String?
    
    private enum CodingKeys: String, CodingKey {
        case code
        case status
        case copyright
        case attributionText
        case attributionHTML
        case comicDataContainer = "data"
        case etag        
    }
    
    public required convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.code = try container.decodeIfPresent(Int.self, forKey: .code)
        self.status = try container.decodeIfPresent(String.self, forKey: .status)
        self.copyright = try container.decodeIfPresent(String.self, forKey: .copyright)
        self.attributionText = try container.decodeIfPresent(String.self, forKey: .attributionText)
        self.attributionHTML = try container.decodeIfPresent(String.self, forKey: .attributionHTML)
        self.etag = try container.decodeIfPresent(String.self, forKey: .etag)
        
        _ = try container.decodeIfPresent(ComicDataContainer.self, forKey: .comicDataContainer)
    }
}
