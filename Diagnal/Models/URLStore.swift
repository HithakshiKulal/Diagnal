//
//  URLStore.swift
//  Diagnal
//
//  Created by Hithakshi on 06/03/22.
//

import Foundation

enum URLStore {
    static func url(for page: Int) -> URL? {
        Bundle.main.url(forResource: "CONTENTLISTINGPAGE-PAGE\(page)", withExtension: "json")
    }
    
    static func url(forImageName name: String) -> URL? {
        Bundle.main.url(forResource: name, withExtension: nil)
    }
    
    static func urlForPlaceHolderImage() -> URL? {
        Bundle.main.url(forResource: "placeholder_for_missing_posters", withExtension: "png")
    }
}
