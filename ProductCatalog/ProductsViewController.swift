//
//  ProductsViewController.swift
//  ProductCatalog
//
//  Created by Lucas Domene Firmo on 11/8/16.
//  Copyright © 2016 Domene. All rights reserved.
//

import UIKit
import Kingfisher

class ProductsViewController: UICollectionViewController {

    var productStore: ProductStore!
    let productDataSource = ProductDataSource()
    var currentPage = 1
    var isLastPage = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.dataSource = productDataSource
        self.fetchProducts()
    }
    
    func fetchProducts(completion: (() -> ())? = nil) {
        productStore.fetchProducts(page: currentPage, sort: .ASC) { productResult in
            switch productResult {
            case .Success(let products):
                OperationQueue.main.addOperation {
                    self.productDataSource.products.append(contentsOf: products)
                    self.collectionView?.reloadData()
                }
            case .Failure(let error):
                print(error)
                // Treat Error
            }
            completion?()
        }
    }
    
    func loadNextPage() {
        if !isLastPage {
            currentPage += 1
            fetchProducts()
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == productDataSource.products.count - 4 {
            loadNextPage()
        }
        
        let product = productDataSource.products[indexPath.row]
        var imageURL: URL?
        do {
            try imageURL = product.thumbnailImage?.asURL()
            ImageDownloader.default.downloadImage(with: imageURL!, options: nil, progressBlock: nil) { (image, _, _, _) in
                let productIndex = self.productDataSource.products.index(of: product)
            }
        } catch {
            //Treat Error
        }
        
        
        (cell as? ProductCell)?.productImageView.kf.setImage(with: imageURL)
    }

}

