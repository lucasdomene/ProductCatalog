//
//  ProductDataSource.swift
//  ProductCatalog
//
//  Created by Lucas Domene Firmo on 11/8/16.
//  Copyright © 2016 Domene. All rights reserved.
//

import Foundation
import UIKit

class ProductDataSource: NSObject, UICollectionViewDataSource {
    
    // MARK: - Attributes
    
    var products = [Product]()
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath) as! ProductCell
        
        if let product = product(indexPath: indexPath) {
            cell.fill(product: product)
        }
        
        cell.layer.borderWidth = 0.5
        cell.layer.borderColor = UIColor.lightGray.cgColor
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "ProductHeader", for: indexPath) as! ProductHeaderView
        
        headerView.delegate = collectionView.delegate as! ProductsViewController
        headerView.searchBar.delegate = collectionView.delegate as! ProductsViewController
        
        return headerView
    }
    
    // MARK: Helper Methods
    
    func product(indexPath: IndexPath) -> Product? {
        if products.count > indexPath.row && indexPath.row >= 0 {
            return products[indexPath.row]
        }
        return nil
    }
    
}
