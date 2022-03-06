//
//  ListViewModel.swift
//  Diagnal
//
//  Created by Hithakshi on 06/03/22.
//

import Foundation

protocol ListViewDelegate: AnyObject {
    func didStartLoading()
    func didFinishLoadingData()
    func didFinishLoading(with error: Error)
}

protocol ListViewProtocol {
    
    var delegate: ListViewDelegate? { get set }
    
    var numberOfItems: Int { get }
    
    func item(at index: Int) -> ContentItem?

}


class ListViewModel: ListViewProtocol {
    
    // MARK: Private properties
    private lazy var dataSource: [ContentItem] = []
    private let contentLoader: ContentLoaderProtocol
    
    // MARK: Internal properties
    weak var delegate: ListViewDelegate?
    var numberOfItems: Int { dataSource.count }
    
    // MARK: Initialisation
    init(contentLoader: ContentLoaderProtocol) {
        self.contentLoader = contentLoader
    }
    
    var canLoadMore: Bool {
        contentLoader.canLoadMore
    }
    
    // MARK: Internal methods
    func item(at index: Int) -> ContentItem? {
        dataSource[safe: index]
    }
    
    func fetchNextPageIfNeeded(currentDisplayingItemIndex: Int) {
        if currentDisplayingItemIndex.isInRange(max: numberOfItems), canLoadMore {
            fetchContents()
        }
    }
    
    func fetchContents() {
        delegate?.didStartLoading()
        guard canLoadMore else { return }
        contentLoader.load { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let items):
                self.dataSource.append(contentsOf: items)
                self.delegate?.didFinishLoadingData()
            case .failure(let error):
                self.delegate?.didFinishLoading(with: error)
            }
        }
    }
    
}

extension Array {
    subscript(safe index: Int) -> Element? {
        self.indices.contains(index) ? self[index] : nil
    }
}

extension Int {
    func isInRange(max: Int, diff: Int = 10) -> Bool {
        ((max - diff)...max).contains(self)
    }
}
