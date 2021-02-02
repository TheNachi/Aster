//
//  ProductDetailsViewModelTests.swift
//  AsterTests
//
//  Created by Munachimso Ugorji on 02/02/2021.
//

import XCTest
@testable import Aster

class ProductDetailsViewModelTests: XCTestCase {
    let productDetails = ProductModel(id: 1, productName: "first product", productDescription: "A random first product", image: ImageModel(width: 200, height: 215, url: "a url"), price: 234)
    

    func testGetProductUrl() {
        let viewModel = ProductDetailsViewModel(with: productDetails),
            productUrl = viewModel.getProductUrl()
        
        XCTAssertEqual(productUrl, "a url")
        
    }
    
    func testGetProductDescription() {
        let viewModel = ProductDetailsViewModel(with: productDetails),
            productDescription = viewModel.getProductDescription()
        
        XCTAssertEqual(productDescription, "A random first product")
    }
    
    func testGetProductPrice() {
        let viewModel = ProductDetailsViewModel(with: productDetails),
            productPrice = viewModel.getProductPrice()
        
        XCTAssertEqual(productPrice, "$234")
    }
}
