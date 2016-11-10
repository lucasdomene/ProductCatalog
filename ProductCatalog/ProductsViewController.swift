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
    @IBOutlet var spinner: UIActivityIndicatorView!
    
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
    
    var isRefreshing = false
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.dataSource = productDataSource
        clearButton.isEnabled = isSearchActive
        
        createRefreshControl()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ProductsViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        self.fetchProducts()
    }
    
    // MARK: - Data Fetchers
    
    func fetchProducts(completion: (() -> ())? = nil) {
        startLoading()
        productStore.fetchProducts(page: currentPage, sort: sortType) { productResult in
            switch productResult {
            case .Success(let products):
                OperationQueue.main.addOperation {
                    self.productDataSource.products.append(contentsOf: products)
                    self.collectionView?.reloadData()
                }
            case .Failure(let error):
                print("Error fetching products: \(error.localizedDescription)")

                if error == .RequestError {
                    let alertController = UIAlertController.alert(withRetryClosure: { 
                        self.fetchProducts()
                    })
                    self.present(alertController, animated: true, completion: nil)
                }
            }
            completion?()
            self.stopLoading()
        }
    }
    
    func searchProducts(searchTerm: String, completion: (() -> ())? = nil) {
        startLoading()
        productStore.searchProduct(searchTerm: searchTerm, page: currentPage, sort: sortType) { productResult in
            switch productResult {
            case .Success(let products):
                OperationQueue.main.addOperation {
                    self.productDataSource.products.append(contentsOf: products)
                    self.collectionView?.reloadData()
                }
            case .Failure(let error):
                print("Error searching products: \(error.localizedDescription)")
                if error == .RequestError {
                    let alertController = UIAlertController.alert(withRetryClosure: {
                        self.searchProducts(searchTerm: self.searchTerm!)
                    })
                    self.present(alertController, animated: true, completion: nil)
                }
            }
            completion?()
            self.stopLoading()
        }
    }
    
    // MARK: - Paging
    
    func loadNextPage() {
        if !isLastPage {
            currentPage += 1
            isSearchActive ? searchProducts(searchTerm: searchTerm!) : fetchProducts()
        }
    }
    
    // MARK: - Ordering
    
    func orderingChangedTo(sortType: BestBuyAPI.ListProductsSort) {
        if self.sortType == sortType {
            return
        }
        
        self.sortType = sortType
        
        resetDataSource()
        isSearchActive ? searchProducts(searchTerm: searchTerm!) : fetchProducts()
    }
    
    // MARK: - Searching
    
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
    
    func dismissKeyboard() {
        (collectionView?.supplementaryView(forElementKind: "UICollectionElementKindSectionHeader", at: IndexPath(row: 0, section: 0)) as? ProductHeaderView)?.searchBar.resignFirstResponder()
    }
    
    // MARK: - UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == productDataSource.products.count - 2 {
            loadNextPage()
        }
        
        setImage(atCell: (cell as! ProductCell), forItemAt: indexPath)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let product = productDataSource.product(indexPath: indexPath) {
            performSegue(withIdentifier: "showProductDetails", sender: product)
        }
    }
    
    // MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showProductDetails" {
            if let productDetailsViewController = segue.destination as? ProductDetailsViewController, let product = sender as? Product {
                productDetailsViewController.product = product
            }
        }
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
        if let product = productDataSource.product(indexPath: indexPath) {
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
    }
    
    func setDefaultImage(cell: ProductCell) {
        cell.productImageView.image = UIImage(named: "no_image")
        cell.stopSpinner()
    }
    
    // MARK: - Pull to Refresh
    
    func createRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(ProductsViewController.refreshProducts(sender:)), for: .valueChanged)
        collectionView?.addSubview(refreshControl)
    }
    
    func refreshProducts(sender: UIRefreshControl) {
        resetDataSource()
        isRefreshing = true
        
        if isSearchActive {
            searchProducts(searchTerm: searchTerm!, completion: { 
                sender.endRefreshing()
                self.isRefreshing = false
            })
        } else {
            fetchProducts(completion: { 
                sender.endRefreshing()
                self.isRefreshing = false
            })
        }
    }
    
    // MARK: - Loading
    
    func startLoading() {
        if !isRefreshing {
            spinner.startAnimating()
        }
    }
    
    func stopLoading() {
        if !isRefreshing {
            spinner.stopAnimating()
        }
    }
    

}

