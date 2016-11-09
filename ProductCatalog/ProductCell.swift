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
        nameLabel.text = product.name
        brandLabel.text = product.brand
        priceLabel.text = "$ \(product.price)"
    }
    
    func updateWithImage(image: UIImage?) {
        if let imageToDisplay = image {
            spinner.stopAnimating()
            productImageView.image = imageToDisplay
        } else {
            spinner.startAnimating()
            productImageView.image = nil
        }
    }
    
    func clean() {
        nameLabel.text = "Untitled"
        brandLabel.text = "No brand"
        priceLabel.text = "No value"
        updateWithImage(image: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        updateWithImage(image: nil)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        updateWithImage(image: nil)
    }
}
