//
//  ProductsViewController.swift
//  ProductCatalog
//
//  Created by Lucas Domene Firmo on 11/8/16.
//  Copyright © 2016 Domene. All rights reserved.
//

import UIKit

class ProductsViewController: UICollectionViewController {

    var productStore: ProductStore!
    let productDataSource = ProductDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.dataSource = productDataSource
        
        productStore.fetchProducts(page: 1, sort: .ASC) { productResult in
            switch productResult {
            case .Success(let products):
                print(products)
                OperationQueue.main.addOperation {
                    self.productDataSource.products.append(contentsOf: products)
                    self.collectionView?.reloadData()
                }
            case .Failure(let error):
                print(error)
                // Treat Error
            }
        }
    }
    

}

