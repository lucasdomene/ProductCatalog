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

/// Possible results when fetching or searching for products
enum ProductResult {
    case Success([Product])
    case Failure(ProductError)
}

/// Possible errors when fetching or searching for products
enum ProductError: Error {
    case MappingError
    case RequestError
    case JSONError
}

class ProductStore {
    
    // MARK: - Data Fetchers
    
    /// Fetch for products
    /// - parameter page: The page to be retrieved from API
    /// - parameter sort: The sort option when fetching products (price ASC or DESC)
    /// - parameter completion: The completion closure for ProductResult
    func fetchProducts(page: Int, sort: BestBuyAPI.ListProductsSort, completion: @escaping (ProductResult) -> Void) {
        Alamofire.request(BestBuyAPI.ListProducts(page: page, sort: sort)).responseJSON { response in
            completion(self.handleResponse(response: response))
        }
    }
    
    /// Search for products
    /// - parameter searchTerm: The search term to filter the API results
    /// - parameter page: The page to be retrieved from API
    /// - parameter sort: The sort option when fetching products (price ASC or DESC)
    /// - parameter completion: The completion closure for ProductResult
    func searchProduct(searchTerm: String, page: Int, sort: BestBuyAPI.ListProductsSort, completion: @escaping (ProductResult) -> Void) {
        Alamofire.request(BestBuyAPI.SearchProduct(searchTerm: searchTerm, page: page, sort: sort)).responseJSON { response in
            completion(self.handleResponse(response: response))
        }
    }
    
    // MARK: - Helper Methods
    
    /// Handle the response from API
    /// - parameter response: The response sent back from Alamofire call
    /// - returns: A ProductResult containing an array of products or an error
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
