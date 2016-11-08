//
//  ViewController.swift
//  ProductCatalog
//
//  Created by Lucas Domene Firmo on 11/8/16.
//  Copyright © 2016 Domene. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        var products: [Product]?
        Alamofire.request(BestBuyAPI.ListProducts(page: 1, sort: .ASC)).responseJSON { response in
            if let json = response.result.value as? [String: Any] {
                if let productsJSON = json["products"] as? [[String: Any]] {
                    products = Mapper<Product>().mapArray(JSONArray: productsJSON)
                }
            }
        }
        
    }

}

