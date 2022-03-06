//
//  APIClient.swift
//  Diagnal
//
//  Created by Hithakshi on 04/03/22.
//

import Foundation

public typealias APIClientResult = Result<Data, Error>

public protocol APIClient {
    func getData(url: URL, completion: @escaping (APIClientResult) -> Void)
}

class LocalAPIClient: APIClient {
    func getData(url: URL, completion: @escaping (APIClientResult) -> Void) {
        let fileURL = URL(fileURLWithPath: url.path)
        do {
            let data = try Data(contentsOf: fileURL)
            completion(.success(data))
        } catch {
            completion(.failure(error))
        }
    }
    
    
}
