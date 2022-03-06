//
//  PosterCollectionViewCell.swift
//  Diagnal
//
//  Created by Hithakshi on 06/03/22.
//

import UIKit

class PosterCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureView()
    }
    
    private func configureView() {
        titleLabel.font = .systemFont(ofSize: 16, weight: .regular)
        titleLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        posterImageView.contentMode = .scaleAspectFill
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        posterImageView.image = nil
    }
    
    func setup(with itemModel: ContentItemViewModel) {
        titleLabel.text = itemModel.item.name
        loadImage(for: itemModel)
    }
    
    private func loadImage(for itemModel: ContentItemViewModel) {
        guard let url = itemModel.imageURL else {
            return setPlaceHolder(itemModel: itemModel)
        }
        ImageCache.publicCache.load(url: url as NSURL, item: itemModel.item) { [weak self] (fetchedItem, image) in
            guard let self = self else { return }
            guard let image = image else {
                self.setPlaceHolder(itemModel: itemModel)
                return
            }
            self.posterImageView.image = image
        }
    }
    
    private func setPlaceHolder(itemModel: ContentItemViewModel) {
        guard let placeHolderImageURL = itemModel.placeHolderImageURL,
              let placeHolderImage = UIImage(contentsOfFile: placeHolderImageURL.path) else {
                  return
              }
        self.posterImageView.image = placeHolderImage
    }
    
}
