//
//  BestBuyAPI.swift
//  ProductCatalog
//
//  Created by Lucas Domene Firmo on 11/8/16.
//  Copyright © 2016 Domene. All rights reserved.
//

import Foundation
import Alamofire

/// API for listing and searching products of BestBuy
enum BestBuyAPI: URLRequestConvertible {
    
    // MARK: - Attributes
    
    static let baseURLString = "https://api.bestbuy.com/v1"
    static let apiKey = "bd6j9ut3parb7csptftw74b5"

    /// Available sorting options
    enum ListProductsSort {
        case DESC;
        case ASC;
        var value: String {
            switch self {
            case .ASC:
                return "asc";
            case .DESC:
                return "desc";
            }
        }
    }
    
    /// Http method according to route
    var method: HTTPMethod {
        switch self {
        case .ListProducts, .SearchProduct:
            return .get
        }
    }
    
    /// Path according to route
    var path: String {
        switch self {
        case .ListProducts:
            return "/products"
        case .SearchProduct(let searchTerm, _, _):
            return "/products(search=\(searchTerm))"
        }
    }
    
    /// Parameters according to route
    var parameters: [String : Any] {
        switch self {
        case .ListProducts(let page, let sort), .SearchProduct(_, let page, let sort):
            return ["page" : page, "sort": "salePrice.\(sort.value)", "apiKey": BestBuyAPI.apiKey, "format": "json", "type": "game", "pageSize": UIDevice.current.userInterfaceIdiom == .pad ? 25 : 10]
        }
    }
    
    // MARK: - Routes
    
    case ListProducts(page: Int, sort: ListProductsSort)
    case SearchProduct(searchTerm: String, page: Int, sort: ListProductsSort)
    
    // MARK: - URLRequestConvertible
    
    func asURLRequest() throws -> URLRequest {
        let url = try BestBuyAPI.baseURLString.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
        
        return urlRequest
    }
}
