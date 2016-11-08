//
//  BestBuyAPI.swift
//  ProductCatalog
//
//  Created by Lucas Domene Firmo on 11/8/16.
//  Copyright © 2016 Domene. All rights reserved.
//

import Foundation
import Alamofire

enum BestBuyAPI: URLRequestConvertible {
    static let baseURLString = "https://api.bestbuy.com/v1"
    static let apiKey = "bd6j9ut3parb7csptftw74b5"

    case ListProducts(page: Int, sort: ListProductsSort)
    
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
    
    var method: HTTPMethod {
        switch self {
        case .ListProducts:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .ListProducts:
            return "/products"
        }
    }
    
    var parameters: [String : Any] {
        switch self {
        case .ListProducts(let page, let sort):
            return ["page" : page, "sort": "salePrice.\(sort.value)", "apiKey": BestBuyAPI.apiKey, "format": "json"]
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = try BestBuyAPI.baseURLString.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
        
        return urlRequest
    }
}
