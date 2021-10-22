//
//  ComicDataWrapper.swift
//  Marvel Heroes
//
//  Created by Александр Цыганков on 10.10.2021.
//

import Foundation

struct ComicDataWrapper {
    let code: Int?
    let status: String?
    let copyright: String?
    let attributionText: String?
    let attributionHTML: String?
    let data: ComicDataContainer?
    let etag: String?
    
    enum CodingKeys: String, CodingKey {
        case code
        case status
        case copyright
        case attributionText
        case attributionHTML
        case data
        case etag
    }
}

extension ComicDataWrapper: Decodable {
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.code = try container.decodeIfPresent(Int.self, forKey: .code)
        self.status = try container.decodeIfPresent(String.self, forKey: .status)
        self.copyright = try container.decodeIfPresent(String.self, forKey: .copyright)
        self.attributionText = try container.decodeIfPresent(String.self, forKey: .attributionText)
        self.attributionHTML = try container.decodeIfPresent(String.self, forKey: .attributionHTML)
        self.data = try container.decodeIfPresent(ComicDataContainer.self, forKey: .data)
        self.etag = try container.decodeIfPresent(String.self, forKey: .etag)
    }
}

extension ComicDataWrapper: Encodable {
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(code, forKey: .code)
        try container.encodeIfPresent(status, forKey: .status)
        try container.encodeIfPresent(copyright, forKey: .copyright)
        try container.encodeIfPresent(attributionText, forKey: .attributionText)
        try container.encodeIfPresent(attributionHTML, forKey: .attributionHTML)
        try container.encodeIfPresent(data, forKey: .data)
        try container.encodeIfPresent(etag, forKey: .etag)
    }
}

