//
//  Product.swift
//  ProductCatalog
//
//  Created by Lucas Domene Firmo on 11/8/16.
//  Copyright © 2016 Domene. All rights reserved.
//

import Foundation
import ObjectMapper

class Product: Mappable, Equatable {
    
    var id: Int?
    var name: String?
    var brand: String?
    var price: Double?
    var description: String?
    var thumbnailImage: String?
    var largeImage: String?
    
    required init?(map: Map) { }
    
    public static func ==(lhs: Product, rhs: Product) -> Bool {
        return lhs.id == rhs.id
    }
}
