//
//  FiatCollectionViewController.swift
//  crypto
//
//  Created by Алексей on 19.12.2020.
//

import UIKit
import Foundation

private let reuseIdentifier = "FiatCell"


class FiatCollectionViewController: UICollectionViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "FiatCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    override func viewDidLayoutSubviews() {
        let cellWidth = view.frame.width - 40
        let cellHeight = view.frame.height - 20
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        
        let insetX = (view.frame.width - cellWidth)/2.0
        let insetY = (view.frame.height - cellHeight)/2.0
        
        collectionView.contentInset = UIEdgeInsets(top: insetY, left: insetX, bottom: insetY, right: insetX)
    }
}

extension FiatCollectionViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        return cell
    }

    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let cellWidthWithSpacing = layout.itemSize.width + layout.minimumLineSpacing
        
        var offset = targetContentOffset.pointee
        let idx = round((offset.x + scrollView.contentInset.left)/cellWidthWithSpacing)
        offset = CGPoint(x: idx * cellWidthWithSpacing - scrollView.contentInset.left + 20, y: scrollView.contentInset.top)
        targetContentOffset.pointee = offset

    }
}



