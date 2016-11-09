//
//  ProductTableViewCell.swift
//  ProductCatalog
//
//  Created by Lucas Domene Firmo on 11/8/16.
//  Copyright © 2016 Domene. All rights reserved.
//

import UIKit

class ProductCell: UICollectionViewCell {

    @IBOutlet var productImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var brandLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var spinner: UIActivityIndicatorView!
 
    func fill(product: Product) {
        clean()
        nameLabel.text = product.name ?? "Unknown"
        brandLabel.text = product.brand ?? "Unknown"
        priceLabel.text = product.price != nil ? "$ \(product.price!)" : "No value"
    }
    
    func startSpinner() {
        spinner.startAnimating()
    }
    
    func stopSpinner() {
        spinner.stopAnimating()
    }
    
    func clean() {
        nameLabel.text = "Untitled"
        brandLabel.text = "No brand"
        priceLabel.text = "No value"
        productImageView.image = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        startSpinner()
        layer.borderWidth = 2
        layer.borderColor = UIColor.blue.cgColor
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        startSpinner()
    }
}
