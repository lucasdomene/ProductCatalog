//
//  ProductsViewController.swift
//  ProductCatalog
//
//  Created by Lucas Domene Firmo on 11/8/16.
//  Copyright © 2016 Domene. All rights reserved.
//

import UIKit

class ProductsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ProductStore().fetchProducts(page: 1, sort: .ASC) { productResult in
            switch productResult {
            case .Success(let products):
                print(products)
                // Set products to data source
            case .Failure(let error):
                print(error)
                // Treat Error
            }
        }
        
        ProductStore().searchProduct(searchTerm: "xbox", page: 1, sort: .ASC) { (productResult) in
            switch productResult {
            case .Success(let products):
                print(products)
            // Set products to data source
            case .Failure(let error):
                print(error)
                // Treat Error
            }
        }
    }

}

