//
//  ContentFeedMapper.swift
//  Diagnal
//
//  Created by Hithakshi on 06/03/22.
//

import Foundation

internal final class ContentFeedMapper {
    struct FetchResponse: Codable {
        let page: PaginatedResult
        
        var items: [ContentItem] {
            page.contentItems.content
        }
        
        struct PaginatedResult: Codable {
            let title: String
            let totalItems: String
            let pageNumber: String
            let pageSize: String
            let contentItems: Content
            
            enum CodingKeys: String, CodingKey {
                case title
                case totalItems = "total-content-items"
                case pageNumber = "page-num"
                case pageSize = "page-size"
                case contentItems = "content-items"
            }
            
            struct Content: Codable {
                let content: [ContentItem]
            }
        }
    }

    static func map(data: Data) throws -> FetchResponse {
        do {
            return try JSONDecoder().decode(FetchResponse.self, from: data)
        }
        catch {
            throw ContentLoader.Error.invalidData
        }
    }
}
