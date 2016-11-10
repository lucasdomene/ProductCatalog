//
//  ProductsViewController.swift
//  ProductCatalog
//
//  Created by Lucas Domene Firmo on 11/8/16.
//  Copyright © 2016 Domene. All rights reserved.
//

import UIKit
import Kingfisher

class ProductsViewController: UICollectionViewController, OrderingSegmentedControlDelegate, UISearchBarDelegate {

    // MARK: - @IBOutlets
    
    @IBOutlet var clearButton: UIBarButtonItem!
    
    // MARK: - Attributes
    
    var productStore: ProductStore!
    let productDataSource = ProductDataSource()
    
    var currentPage = 1
    var isLastPage = false
    
    var searchTerm: String?
    var isSearchActive = false {
        didSet {
            clearButton.isEnabled = isSearchActive
        }
    }
    
    var sortType = BestBuyAPI.ListProductsSort.DESC
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.dataSource = productDataSource
        clearButton.isEnabled = isSearchActive
        
        self.fetchProducts()
    }
    
    // MARK: - Data Fetchers
    
    func fetchProducts(completion: (() -> ())? = nil) {
        productStore.fetchProducts(page: currentPage, sort: sortType) { productResult in
            switch productResult {
            case .Success(let products):
                OperationQueue.main.addOperation {
                    self.productDataSource.products.append(contentsOf: products)
                    self.collectionView?.reloadData()
                }
            case .Failure(let error):
                print(error)
                // TODO: Treat Error
            }
            completion?()
        }
    }
    
    func searchProducts(searchTerm: String, completion: (() -> ())? = nil) {
        productStore.searchProduct(searchTerm: searchTerm, page: currentPage, sort: sortType) { productResult in
            switch productResult {
            case .Success(let products):
                OperationQueue.main.addOperation {
                    self.productDataSource.products.append(contentsOf: products)
                    self.collectionView?.reloadData()
                }
            case .Failure(let error):
                print(error)
                // TODO: Treat Error
            }
        }
    }
    
    // MARK: Paging
    
    func loadNextPage() {
        if !isLastPage {
            currentPage += 1
            isSearchActive ? searchProducts(searchTerm: searchTerm!) : fetchProducts()
        }
    }
    
    // MARK: Ordering
    
    func orderingChangedTo(sortType: BestBuyAPI.ListProductsSort) {
        if self.sortType == sortType {
            return
        }
        
        self.sortType = sortType
        
        resetDataSource()
        isSearchActive ? searchProducts(searchTerm: searchTerm!) : fetchProducts()
    }
    
    // MARK: Searching
    
    @IBAction func clearSearch(_ sender: UIBarButtonItem) {
        isSearchActive = false
        resetDataSource()
        
        (collectionView?.supplementaryView(forElementKind: "UICollectionElementKindSectionHeader", at: IndexPath(row: 0, section: 0)) as? ProductHeaderView)?.searchBar.text = ""
        
        fetchProducts()
    }
    
    // MARK: - Helper Methods
    
    func resetDataSource() {
        productDataSource.products = [Product]()
        currentPage = 1
        isLastPage = false
    }
    
    // MARK: - UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == productDataSource.products.count - 2 {
            loadNextPage()
        }
        
        setImage(atCell: (cell as! ProductCell), forItemAt: indexPath)
    }
    
    // MARK: - SearchBarDelegate
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchTerm = searchBar.text, !searchTerm.isEmpty {
            isSearchActive = true
            resetDataSource()
            self.searchTerm = searchTerm
            searchProducts(searchTerm: searchTerm)
            searchBar.resignFirstResponder()
        }
    }
    
    // MARK: - Image Handler
    
    func setImage(atCell cell: ProductCell, forItemAt indexPath: IndexPath) {
        let product = productDataSource.products[indexPath.row]
        var imageURL: URL?
        do {
            try imageURL = product.thumbnailImage?.asURL()
            
            guard imageURL != nil else {
                setDefaultImage(cell: cell)
                return
            }
            
            ImageDownloader.default.downloadImage(with: imageURL!) { (image, _, _, _) in
                if let productRow = self.productDataSource.products.index(of: product) {
                    let productIndexPath = IndexPath(row: productRow, section: 0)
                    if let cell = self.collectionView?.cellForItem(at: productIndexPath) as? ProductCell {
                        OperationQueue.main.addOperation {
                            cell.productImageView.image = image ?? UIImage(named: "no_image")
                            cell.stopSpinner()
                        }
                    }
                }
            }
        } catch {
            setDefaultImage(cell: cell)
        }
    }
    
    func setDefaultImage(cell: ProductCell) {
        cell.productImageView.image = UIImage(named: "no_image")
        cell.stopSpinner()
    }
    

}

