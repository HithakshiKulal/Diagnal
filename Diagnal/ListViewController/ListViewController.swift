//
//  ListViewController.swift
//  Diagnal
//
//  Created by Hithakshi on 06/03/22.
//

import UIKit

class ListViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var titleLabel: UILabel!
    
    private let viewModel: ListViewModel = {
        ListViewModel(contentLoader: ContentLoader(apiClient: LocalAPIClient()))
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        setup()
        viewModel.fetchContents()
    }
    
    private func configure() {
        PosterCollectionViewCell.register(with: collectionView)
        view.backgroundColor = .black
        titleLabel.font = .systemFont(ofSize: 16, weight: .regular)
        titleLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private func setup() {
        titleLabel.text = Constants.title
        viewModel.delegate = self
    }

}

extension ListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PosterCollectionViewCell.name, for: indexPath) as! PosterCollectionViewCell
        if let item = viewModel.item(at: indexPath.row) {
            cell.setup(with: .init(item: item))
        }
        return cell
    }
}

extension ListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width / 3) - Constants.minInterItemSpacing
        return CGSize(
            width: width,
            height: Constants.cellHeight
        )
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        Constants.minLineSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        Constants.minInterItemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        viewModel.fetchNextPageIfNeeded(currentDisplayingItemIndex: indexPath.row)
    }
}

extension ListViewController: ListViewDelegate {
    func didStartLoading() { }
    
    func didFinishLoadingData() {
        UIView.animate(withDuration: 1, delay: 0, options: .layoutSubviews) {
            self.collectionView.reloadData()
        }
    }
    
    func didFinishLoading(with error: Error) { }
    
}

//MARK: Constants
extension ListViewController {
    
    private enum Constants {
        static let title = "Romantic Comedy"
        static let minLineSpacing: CGFloat = 16
        static let minInterItemSpacing: CGFloat = 8
        static let cellHeight: CGFloat = 200
    }
}


extension NSObject {
    static var name: String { String(describing: Self.self) }
}
