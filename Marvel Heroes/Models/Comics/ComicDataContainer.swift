//
//  ComicDataContainer.swift
//  Marvel Heroes
//
//  Created by Александр Цыганков on 10.10.2021.
//

import Foundation
import RealmSwift

class ComicDataContainer: Object, Decodable {
    @Persisted var offset: Int?
    @Persisted var limit: Int?
    @Persisted var total: Int?
    @Persisted var count: Int?
    var comicList = List<Comic>()
    
    private enum CodingKeys: String, CodingKey {
        case offset
        case limit
        case total
        case count
        case comicList = "results"
    }
    
    public required convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.offset = try container.decodeIfPresent(Int.self, forKey: .offset)
        self.limit = try container.decodeIfPresent(Int.self, forKey: .limit)
        self.total = try container.decodeIfPresent(Int.self, forKey: .total)
        self.count = try container.decodeIfPresent(Int.self, forKey: .count)
        let comic = try container.decodeIfPresent([Comic].self, forKey: .comicList)
    }
    
    
    
}
