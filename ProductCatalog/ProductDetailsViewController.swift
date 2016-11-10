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
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(ProductDetailsViewController.share))
        
        if let product = self.product {
            fill(product: product)
            title = product.name
        }
    }
    
    // MARK: - Helper Methods
    
    /// Fill @IBOutlets with selected product data
    /// - parameter product: The selected product
    func fill(product: Product) {
        nameLabel.text = product.name ?? "Unknown"
        brandLabel.text = product.brand ?? "Unknown"
        priceLabel.text = product.price != nil ? "$ \(product.price!)" : "No value"
        descriptionLabel.text = product.description ?? "No description"
        
        getImage { image in
            OperationQueue.main.addOperation {
                self.imageView.image = image
            }
        }
    }
    
    /// Download the large image of the product. If it fails, send the default it back.
    /// - parameter completion: The closure to send data back.
    func getImage(completion: @escaping (UIImage) -> ()) {
        var imageURL: URL?
        do {
            try imageURL = product?.largeImage?.asURL()
            
            guard imageURL != nil else {
                completion(UIImage(named: "no_image")!)
                return
            }
            
            ImageDownloader.default.downloadImage(with: imageURL!) { (image, _, _, _) in
                completion(image ?? UIImage(named: "no_image")!)
            }
        } catch {
            completion(UIImage(named: "no_image")!)
        }
    }
    
    // MARK: - Share
    
    /// Share content using UIActivityIndicator
    func share() {
        if let imageToShare = imageView.image, let productName = nameLabel.text, let productPrice = priceLabel.text {
            let message = "\(productName) for only \(productPrice)!"
            let activityController = UIActivityViewController(activityItems: [message, imageToShare], applicationActivities: nil)
            present(activityController, animated: true, completion: nil)
        }
    }
    
    // MARK: - @IBActions
    
    /// Handle image tap
    @IBAction func zoomPressed(_ sender: AnyObject) {
        if let image = imageView.image {
            performSegue(withIdentifier: "showZoomView", sender: image)
        }
    }
    
    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showZoomView" {
            if let destinationViewController = segue.destination as? ProductZoomViewController, let image = sender as? UIImage {
                destinationViewController.image = image
            }
        }
    }
    
}
