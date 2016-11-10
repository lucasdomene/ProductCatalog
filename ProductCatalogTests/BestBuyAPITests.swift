//
//  BestBuyAPITests.swift
//  ProductCatalog
//
//  Created by Lucas Domene Firmo on 11/10/16.
//  Copyright © 2016 Domene. All rights reserved.
//

import XCTest
@testable import ProductCatalog

class BestBuyAPITests: XCTestCase {
    
    let listProductsData = BestBuyAPI.ListProducts(page: 1, sort: .ASC)
    let searchProductsData = BestBuyAPI.SearchProduct(searchTerm: "test", page: 1, sort: .ASC)
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testParameters() {
        XCTAssertEqual(listProductsData.parameters["page"] as? Int, 1)
        XCTAssertEqual(listProductsData.parameters["apiKey"] as? String, BestBuyAPI.apiKey)
        XCTAssertEqual(listProductsData.parameters["format"] as? String, "json")
        XCTAssertEqual(listProductsData.parameters["type"] as? String, "game")
        XCTAssertEqual(listProductsData.parameters["sort"] as? String, "salePrice.asc")
    }
    
    func testPaths() {
        XCTAssertEqual(listProductsData.path, "/products")
        XCTAssertEqual(searchProductsData.path, "/products(search=test)")
    }
    
    func testHttpMethods() {
        XCTAssertEqual(listProductsData.method, .get)
        XCTAssertEqual(searchProductsData.method, .get)
    }
    
}
