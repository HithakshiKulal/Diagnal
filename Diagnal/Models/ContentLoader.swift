//
//  ContentLoader.swift
//  Diagnal
//
//  Created by Hithakshi on 04/03/22.
//

import Foundation

protocol ContentLoaderProtocol {
    var canLoadMore: Bool { get }
    func load(completion: @escaping ContentLoader.ResultCompletion)
}

public class ContentLoader: ContentLoaderProtocol {
    public typealias Result = (Swift.Result<[ContentItem], Error>)
    public typealias ResultCompletion = (Result) -> Void

    let apiClient: APIClient
    
    private var response: ContentFeedMapper.FetchResponse?
    private var items: [ContentItem] = []
    
    public init(apiClient: APIClient) {
        self.apiClient = apiClient
    }
    
    
    var canLoadMore: Bool {
        guard let response = response else {
            return true
        }
        return items.count < (Int(response.page.totalItems) ?? 0)
    }
    
    public func load(
        completion: @escaping ResultCompletion
    ) {
        do {
            let url = try getURL()
            apiClient.getData(url: url) { result in
                switch result {
                case .failure:
                    completion(.failure(.fetchError))
                case .success(let data):
                    completion(self.map(data))
                }
            }
        } catch {
            completion(.failure(.noMatchingURL))
        }
    }

    
    func getURL() throws -> URL {
        let page = Int(response?.page.pageNumber ?? "0") ?? 0
        guard let url = URLStore.url(for: page + 1) else {
            throw Error.noMatchingURL
        }
        return url
    }
    
    private func map(_ data: Data) -> Result {
        do {
            let response = try ContentFeedMapper.map(data: data)
            self.response = response
            items.append(contentsOf: response.items)
            return .success(response.items)
        } catch {
            return .failure(.invalidData)
        }
    }
    
    public enum Error: Swift.Error {
        case fetchError
        case invalidData
        case noMatchingURL
    }
    
}
