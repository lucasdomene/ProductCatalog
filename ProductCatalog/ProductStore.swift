//
//  ProductStore.swift
//  ProductCatalog
//
//  Created by Lucas Domene Firmo on 11/8/16.
//  Copyright © 2016 Domene. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

enum ProductResult {
    case Success([Product])
    case Failure(ProductError)
}

enum ProductError: Error {
    case MappingError
    case RequestError
    case JSONError
}

class ProductStore {
    
    func fetchProducts(page: Int, sort: BestBuyAPI.ListProductsSort, completion: @escaping (ProductResult) -> Void) {
        Alamofire.request(BestBuyAPI.ListProducts(page: page, sort: sort)).responseJSON { response in
            if let _ = response.result.error {
                completion(.Failure(.RequestError))
                return
            }
            
            if let json = response.result.value as? [String : Any], let productsJSON = json["products"] as? [[String : Any]] {
                guard let products = Mapper<Product>().mapArray(JSONArray: productsJSON) else {
                    completion(.Failure(.MappingError))
                    return
                }
                completion(.Success(products))
            } else {
                completion(.Failure(.JSONError))
            }
        }
    }
    
}
