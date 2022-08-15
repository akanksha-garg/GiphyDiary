//
//  Giphy.swift
//  GiphyDiary
//
//  Created by Akanksha Garg on 15/08/22.
//

import Foundation

/// Presentation model for Giphy data.
struct Giphy: Decodable {
    let giphyData: [GiphyData]
    
    enum CodingKeys: String, CodingKey {
      case giphyData = "data"
   }
}

class GiphyData: Decodable {
    let id: String!
    var isFavorite: Bool = false
    let images: ImageObject?

    enum CodingKeys: String, CodingKey {
        case id, images
    }
}

struct ImageObject: Decodable {
    
    let original: Gif?
    let downsized: Gif?

    enum CodingKeys: String, CodingKey {
        case original = "original"
        case downsized = "downsized"
    }
}

struct Gif: Decodable {
    
    let url: String?
    enum CodingKeys: String, CodingKey {
        case url = "url"
    }
}
