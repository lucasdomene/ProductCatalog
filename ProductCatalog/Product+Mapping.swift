//
//  Product+Mapping.swift
//  ProductCatalog
//
//  Created by Lucas Domene Firmo on 11/8/16.
//  Copyright © 2016 Domene. All rights reserved.
//

import Foundation
import ObjectMapper

extension Product {
    
    /// Map each attribute of a product
    func mapping(map: Map) {
        id <- map["productId"]
        name <- map["name"]
        brand <- map["manufacturer"]
        price <- map["salePrice"]
        description <- map["shortDescription"]
        thumbnailImage <- map["mediumImage"]
        largeImage <- map["largeImage"]
    }
    
}
