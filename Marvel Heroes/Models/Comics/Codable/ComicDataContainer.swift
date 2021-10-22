//
//  ComicDataContainer.swift
//  Marvel Heroes
//
//  Created by Александр Цыганков on 10.10.2021.
//

import Foundation

struct ComicDataContainer {
    let offset: Int?
    let limit: Int?
    let total: Int?
    let count: Int?
    let results: [Comic]?
    
    enum CodingKeys: String, CodingKey {
        case offset
        case limit
        case total
        case count
        case results
    }
}

extension ComicDataContainer: Decodable {
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.offset = try container.decodeIfPresent(Int.self, forKey: .offset)
        self.limit = try container.decodeIfPresent(Int.self, forKey: .limit)
        self.total = try container.decodeIfPresent(Int.self, forKey: .total)
        self.count = try container.decodeIfPresent(Int.self, forKey: .count)
        self.results = try container.decodeIfPresent([Comic].self, forKey: .results)
    }
}

extension ComicDataContainer: Encodable {
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(offset, forKey: .offset)
        try container.encodeIfPresent(limit, forKey: .limit)
        try container.encodeIfPresent(total, forKey: .total)
        try container.encodeIfPresent(count, forKey: .count)
        try container.encodeIfPresent(results, forKey: .results)
    }
}
