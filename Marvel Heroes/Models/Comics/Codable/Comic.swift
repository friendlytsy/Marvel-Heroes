//
//  Comic.swift
//  Marvel Heroes
//
//  Created by Александр Цыганков on 10.10.2021.
//

import Foundation
import RealmSwift

struct Comic {
    
    let id: Int?
    let title: String?
    let description: String?
    let thumbnail: Image?
//    let comics: ComicsList?

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        case thumbnail
        case comics
    }
}

extension Comic: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(Int.self, forKey: .id)
        self.title = try container.decodeIfPresent(String.self, forKey: .title)
        self.description = try container.decodeIfPresent(String.self, forKey: .description)
        self.thumbnail = try container.decodeIfPresent(Image.self, forKey: .thumbnail)
//        self.comics = try container.decodeIfPresent(ComicsList.self, forKey: .comics)
    }
}

extension Comic: Encodable {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(id, forKey: .id)
        try container.encodeIfPresent(title, forKey: .title)
        try container.encodeIfPresent(description, forKey: .description)
        try container.encodeIfPresent(thumbnail, forKey: .thumbnail)
//        try container.encodeIfPresent(comics, forKey: .comics)
    }
}
