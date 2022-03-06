//
//  UIView+Extension.swift
//  OrientSwiss
//
//  Created by Hithakshi on 26/02/22.
//

import UIKit

extension UICollectionReusableView {
    static func registerSupplementary(with collectionView: UICollectionView) {
        collectionView.register(
            UINib(
                nibName: name,
                bundle: nil
            ),
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: name
        )
    }
    
}

extension UICollectionViewCell {
    static func register(with collectionView: UICollectionView) {
        collectionView.register(UINib(nibName: name, bundle: nil), forCellWithReuseIdentifier: name)
    }
}
