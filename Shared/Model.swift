//
//  Model.swift
//  DispatchQueue
//
//  Created by Borna Libertines on 09/02/22.
//

import Foundation

// MARK: APIListResponse Model
/// model from api
struct APIListResponse: Codable {
    var data: [GifObject]
}

struct GifObject: Codable {
    var id: String?
    var title: String?
    var source_tld: String?
    var rating: String?
    /// Giphy URL (not gif url to be displayed)
    var url: URL?
    var images: Images?
    
    struct Images: Codable {
        var fixed_height: Image?
        struct Image: Codable {
            var url: URL?
            var width: String?
            var height: String?
            var mp4: URL?
        }
    }
}

// MARK: SearchResult Model
///model from api
struct SearchResult: Codable {
  var id: String?
  var gifUrl: URL?
  var title: String?
    enum CodingKeys: String, CodingKey {
        case id
        case gifUrl = "url"
        case title
    }
}


// MARK: APGifResponse Model
/// model from api

struct APGifResponse: Codable {
    var data: GifObject
}

// MARK: GifCollectionViewCellViewModel Model
struct GifCollectionViewCellViewModel {
    let id: String?
    let title: String?
    let rating: String?
    let Image: URL?
    let url: URL?
}
// MARK: GifViewCellViewModel Model
struct GifViewCellViewModel {
    let id: String?
    let title: String?
    let rating: String?
    let Image: URL?
    let video: URL?
    let url: URL?
}
