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
    var fiats:[FiatModel]? {
        didSet {
            collectionView.reloadData()
        }
    }
    
    var theme = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "FiatCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        
        theme = UserDefaults.standard.integer(forKey: "theme")
    }
    
    override func viewDidLayoutSubviews() {
        let cellWidth = view.frame.width - 40
        let cellHeight = view.frame.height - 20
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        
        let insetX = (view.frame.width - cellWidth)/2.0
        let insetY = (view.frame.height - cellHeight)/2.0
        
        collectionView.contentInset = UIEdgeInsets(top: insetY, left: insetX - 20, bottom: insetY, right: insetX)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        theme = UserDefaults.standard.integer(forKey: "theme")
    }
}

extension FiatCollectionViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fiats?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FiatCollectionViewCell
        
        cell.layer.cornerRadius = 10
        cell.layer.masksToBounds = true
        
        cell.layer.borderWidth = 2
        cell.layer.borderColor = themeColor[theme]?.cgColor
        
        cell.headerView.backgroundColor = themeColor[theme]
        cell.CurrShowLabel.textColor = themeColor[theme]
        cell.LastUpd.textColor = themeColor[theme]
        cell.configure(with: fiats![indexPath.row])
        
        return cell
    }

    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let cellWidthWithSpacing = layout.itemSize.width + layout.minimumLineSpacing
        
        var offset = targetContentOffset.pointee
        let idx = round((offset.x + scrollView.contentInset.left)/cellWidthWithSpacing)
        offset = CGPoint(x: idx * cellWidthWithSpacing - scrollView.contentInset.left, y: scrollView.contentInset.top)
        targetContentOffset.pointee = offset

    }
}



