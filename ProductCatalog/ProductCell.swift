//
//  ProductTableViewCell.swift
//  ProductCatalog
//
//  Created by Lucas Domene Firmo on 11/8/16.
//  Copyright © 2016 Domene. All rights reserved.
//

import UIKit

class ProductCell: UICollectionViewCell {

    // MARK: - @IBOutlets
    
    @IBOutlet var productImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var brandLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var spinner: UIActivityIndicatorView!
 
    // MARK: - Life Cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        startSpinner()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        startSpinner()
    }
    
    // MARK: - Helper Methods
    
    /// Fill labels content with a given product data
    /// - parameter product: A instance of Product
    func fill(product: Product) {
        clean()
        nameLabel.text = product.name ?? "Unknown"
        brandLabel.text = product.brand ?? "Unknown"
        priceLabel.text = product.price != nil ? "$ \(product.price!)" : "No value"
    }
    
    /// Starts the UIActivityIndicator on cell
    func startSpinner() {
        spinner.startAnimating()
    }
    
    /// Stops the UIActivityIndicator on cell
    func stopSpinner() {
        spinner.stopAnimating()
    }
    
    /// Clean cell content
    func clean() {
        nameLabel.text = "Untitled"
        brandLabel.text = "No brand"
        priceLabel.text = "No value"
        productImageView.image = nil
    }
    
}
