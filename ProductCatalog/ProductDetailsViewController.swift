//
//  ProductDetailsViewController.swift
//  ProductCatalog
//
//  Created by Lucas Domene Firmo on 11/10/16.
//  Copyright © 2016 Domene. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

class ProductDetailsViewController: UIViewController {
    
    // MARK: - Attributes
    
    var product: Product?
    
    // MARK: - @IBOutlets
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var brandLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    
    // MARK: - Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let product = self.product {
            fill(product: product)
        }
    }
    
    // MARK: - Helper Methods
    
    func fill(product: Product) {
        nameLabel.text = product.name ?? "Unknown"
        brandLabel.text = product.brand ?? "Unknown"
        priceLabel.text = product.price != nil ? "$ \(product.price!)" : "No value"
        descriptionLabel.text = product.description ?? "No description"
        imageView.kf.setImage(with: try! product.largeImage?.asURL())
    }
    
}
