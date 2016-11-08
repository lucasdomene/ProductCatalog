//
//  Product.swift
//  ProductCatalog
//
//  Created by Lucas Domene Firmo on 11/8/16.
//  Copyright © 2016 Domene. All rights reserved.
//

import Foundation
import ObjectMapper

class Product: Mappable {
    
    var name: String?
    var brand: String?
    var price: Double?
    var description: String?
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        name <- map["name"]
        brand <- map["manufacturer"]
        price <- map["salePrice"]
        description <- map["description"]
    }
}
