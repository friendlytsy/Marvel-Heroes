//
//  Comic.swift
//  Marvel Heroes
//
//  Created by Александр Цыганков on 10.10.2021.
//

import Foundation
import RealmSwift

class Comic: Object, Decodable {
    @Persisted (primaryKey: true) var id: Int?
    @Persisted var title: String?
    @Persisted var comicDescription: String?
    
    private enum CodingKeys: String, CodingKey {
        case id
        case title
        case comicDescription = "description"
    }
    
    public required convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(Int.self, forKey: .id)
        self.title = try container.decodeIfPresent(String.self, forKey: .title)
        self.comicDescription = try container.decodeIfPresent(String.self, forKey: .comicDescription)
    }
}
