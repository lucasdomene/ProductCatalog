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
            
            guard imageURL != nil else {
                (cell as! ProductCell).productImageView.image = UIImage(named: "no_image")
                (cell as! ProductCell).stopSpinner()
                return
            }

            ImageDownloader.default.downloadImage(with: imageURL!, options: nil, progressBlock: nil) { (image, _, _, _) in
                if let productRow = self.productDataSource.products.index(of: product) {
                    let productIndexPath = IndexPath(row: productRow, section: 0)
                    if let cell = self.collectionView?.cellForItem(at: productIndexPath) as? ProductCell {
                        cell.productImageView.image = image ?? UIImage(named: "no_image")
                        cell.stopSpinner()
                    }
                }
            }
        } catch {
            (cell as! ProductCell).productImageView.image = UIImage(named: "no_image")
            (cell as! ProductCell).stopSpinner()
        }
    }

}

