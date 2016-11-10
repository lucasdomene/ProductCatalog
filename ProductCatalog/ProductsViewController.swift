//
//  ProductsViewController.swift
//  ProductCatalog
//
//  Created by Lucas Domene Firmo on 11/8/16.
//  Copyright © 2016 Domene. All rights reserved.
//

import UIKit
import Kingfisher

class ProductsViewController: UICollectionViewController, OrderingSegmentedControlDelegate, UISearchBarDelegate, UICollectionViewDelegateFlowLayout {

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
    
    var currentCellSize: CGSize?
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(ProductsViewController.didRotateDevice), name: .UIDeviceOrientationDidChange, object: nil)
        
        collectionView?.dataSource = productDataSource
        clearButton.isEnabled = isSearchActive
        
        createRefreshControl()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ProductsViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        self.fetchProducts()
    }
    
    // MARK: - Data Fetchers
    
    /// Fetch products
    /// - parameter completion: Completion closure used to inform the end of fetching data. Optional.
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
    
    /// Search products
    /// - parameter searchTerm: The search term to filter the API results
    /// - parameter completion: Completion closure used to inform the end of fetching data. Optional.
    func searchProducts(searchTerm: String, completion: (() -> ())? = nil) {
        startLoading()
        productStore.searchProduct(searchTerm: searchTerm, page: currentPage, sort: sortType) { productResult in
            switch productResult {
            case .Success(let products):
                OperationQueue.main.addOperation {
                    self.productDataSource.products.append(contentsOf: products)
                    
                    if self.productDataSource.products.count == 0 {
                        self.setEmptyView()
                    }
                    
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
    
    /// Load next page of products.
    func loadNextPage() {
        if !isLastPage {
            currentPage += 1
            isSearchActive ? searchProducts(searchTerm: searchTerm!) : fetchProducts()
        }
    }
    
    // MARK: - Ordering
    
    /// Change the sort order.
    /// - parameter sortType: the new sort option (price ASC or DESC)
    func orderingChangedTo(sortType: BestBuyAPI.ListProductsSort) {
        if self.sortType == sortType {
            return
        }
        
        self.sortType = sortType
        
        resetDataSource()
        isSearchActive ? searchProducts(searchTerm: searchTerm!) : fetchProducts()
    }
    
    // MARK: - Searching
    
    /// Clean search field and search results
    @IBAction func clearSearch(_ sender: UIBarButtonItem) {
        self.collectionView?.backgroundView = spinner
        isSearchActive = false
        resetDataSource()
        
        (collectionView?.supplementaryView(forElementKind: "UICollectionElementKindSectionHeader", at: IndexPath(row: 0, section: 0)) as? ProductHeaderView)?.searchBar.text = ""
        
        fetchProducts()
    }
    
    // MARK: - Helper Methods
    
    /// Set data source and helper attributes to initial values
    func resetDataSource() {
        productDataSource.products = [Product]()
        currentPage = 1
        isLastPage = false
    }
    
    /// Remove keyboard from screen
    func dismissKeyboard() {
        (collectionView?.supplementaryView(forElementKind: "UICollectionElementKindSectionHeader", at: IndexPath(row: 0, section: 0)) as? ProductHeaderView)?.searchBar.resignFirstResponder()
    }
    
    /// Set 'empty' message to background
    func setEmptyView() {
        let emptyLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.height))
        emptyLabel.text = "No results!"
        emptyLabel.textAlignment = .center
        
        self.collectionView?.backgroundView = emptyLabel
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
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if UIDevice.current.userInterfaceIdiom == .phone {
            switch UIDevice.current.orientation {
            case .portrait:
                let width = (self.view.bounds.size.width - 3 * 5) / 2
                currentCellSize = CGSize(width: width, height: width * 1.1)
                return currentCellSize!
            case .landscapeLeft, .landscapeRight:
                let width = (self.view.bounds.size.width - 5 * 5) / 4
                currentCellSize = CGSize(width: width, height: width * 1.1)
                return currentCellSize!
            default:
                return currentCellSize ?? CGSize(width: 150, height: 165)
            }
        } else {
            return CGSize(width: 180, height: 190)
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
        self.collectionView?.backgroundView = self.spinner
        if let searchTerm = searchBar.text, !searchTerm.isEmpty {
            isSearchActive = true
            resetDataSource()
            self.searchTerm = searchTerm
            searchProducts(searchTerm: searchTerm)
            searchBar.resignFirstResponder()
        }
    }
    
    // MARK: - Image Handler
    
    /// Download and set the image to cell. If an error occurs, set the default image instead.
    /// - parameter cell: The ProductCell to set the image to
    /// - parameter indexPath: The indexPath of the cell.
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
    
    /// Set the default image to the cell
    /// - parameter cell: The ProductCell to set the image to
    func setDefaultImage(cell: ProductCell) {
        cell.productImageView.image = UIImage(named: "no_image")
        cell.stopSpinner()
    }
    
    // MARK: - Pull to Refresh
    
    /// Create UIRefreshControl and add to the view
    func createRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(ProductsViewController.refreshProducts(sender:)), for: .valueChanged)
        collectionView?.addSubview(refreshControl)
    }
    
    /// Refresh content
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
    
    /// Starts the UIActivityIndicator on view
    func startLoading() {
        if !isRefreshing {
            spinner.startAnimating()
        }
    }
    
    /// Stops the UIActivityIndicator on view
    func stopLoading() {
        if !isRefreshing {
            spinner.stopAnimating()
        }
    }
    
    // MARK: Rotation
    
    /// Reload the collectionView for layout adjustments.
    func didRotateDevice() {
        switch UIDevice.current.orientation {
        case .faceDown, .faceUp, .portraitUpsideDown, .unknown:
            return
        case .landscapeLeft, .landscapeRight, .portrait:
            self.collectionView?.reloadData()
        }
    }
    

}

