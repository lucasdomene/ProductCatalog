//
//  ProductTests.swift
//  ProductCatalog
//
//  Created by Lucas Domene Firmo on 11/10/16.
//  Copyright © 2016 Domene. All rights reserved.
//

import XCTest
import ObjectMapper
@testable import ProductCatalog

class ProductTests: XCTestCase {
    
    let firstProductJSON: [String: Any] = ["productId": 10, "name": "Test Product", "manufacturer": "Test Brand", "salePrice": Double(100), "shortDescription": "This is a test description", "mediumImage": "Test medium image", "largeImage": "Test large image"]
    
    let secondProductJSON: [String: Any] = ["productId": 20, "name": "Test Product", "manufacturer": "Test Brand", "salePrice": Double(100), "shortDescription": "This is a test description", "mediumImage": "Test medium image", "largeImage": "Test large image"]
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testProductCreation() {
        if let product = Mapper<Product>().map(JSON: firstProductJSON) {
            XCTAssertEqual(product.id, 10)
            XCTAssertEqual(product.name, "Test Product")
            XCTAssertEqual(product.brand, "Test Brand")
            XCTAssertEqual(product.price, 100)
            XCTAssertEqual(product.description, "This is a test description")
            XCTAssertEqual(product.thumbnailImage, "Test medium image")
            XCTAssertEqual(product.largeImage, "Test large image")
        } else {
            XCTFail("Could not create product")
        }
    }
    
    func testEqualProducts() {
        if let firstProduct = Mapper<Product>().map(JSON: firstProductJSON) {
            XCTAssertTrue(firstProduct == firstProduct)
        }
    }
    
    func testDifferentProducts() {
        if let firstProduct = Mapper<Product>().map(JSON: firstProductJSON), let secondProduct = Mapper<Product>().map(JSON: secondProductJSON) {
            XCTAssertFalse(firstProduct == secondProduct)
        }
    }
    
}
