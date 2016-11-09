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
            completion(self.handleResponse(response: response))
        }
    }
    
    func searchProduct(searchTerm: String, page: Int, sort: BestBuyAPI.ListProductsSort, completion: @escaping (ProductResult) -> Void) {
        Alamofire.request(BestBuyAPI.SearchProduct(searchTerm: searchTerm, page: page, sort: sort)).responseJSON { response in
            completion(self.handleResponse(response: response))
        }
    }
    
    func handleResponse(response: DataResponse<Any>) -> ProductResult {
        if let _ = response.result.error {
            return .Failure(.RequestError)
        }
        
        if let json = response.result.value as? [String : Any], let productsJSON = json["products"] as? [[String : Any]] {
            guard let products = Mapper<Product>().mapArray(JSONArray: productsJSON) else {
                return .Failure(.MappingError)
            }
            return .Success(products)
        } else {
            return .Failure(.JSONError)
        }
    }
    
}
