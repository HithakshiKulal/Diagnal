//
//  ContentItem.swift
//  Diagnal
//
//  Created by Hithakshi on 04/03/22.
//

import Foundation

public struct ContentItem: Equatable, Codable {
    var name: String
    var posterImage: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case posterImage = "poster-image"
    }
}
public struct ContentItemViewModel {
    var item: ContentItem
    
    var imageURL: URL? {
        URLStore.url(forImageName: item.posterImage)
    }
    
    var placeHolderImageURL: URL? {
        URLStore.urlForPlaceHolderImage()
    }
}
