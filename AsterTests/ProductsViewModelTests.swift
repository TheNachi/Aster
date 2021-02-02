//
//  ProductsViewModelTests.swift
//  AsterTests
//
//  Created by Munachimso Ugorji on 02/02/2021.
//

import XCTest
@testable import Aster

class ProductsViewModelTests: XCTestCase {
    let products = [
        ProductModel(id: 1, productName: "first product", productDescription: "A random first product", image: ImageModel(width: 200, height: 215, url: "a url"), price: 234),
        ProductModel(id: 2, productName: "second product", productDescription: "A random second product", image: ImageModel(width: 180, height: 200, url: "a second url"), price: 200)
    ]
    
    func testGetProductsCount() {
        let viewModel = ProductsViewModel(with: nil)
        viewModel.updateProduct(response: products)

        XCTAssertEqual(viewModel.getProductsCount(), 2)
    }
    
    func testGetImageHeightFor() {
        let viewModel = ProductsViewModel(with: nil)
        viewModel.updateProduct(response: products)
        
        XCTAssertEqual(viewModel.getImageHeightFor(width: 200, at: 0), 235.0)
        XCTAssertEqual(viewModel.getImageHeightFor(width: 180, at: 1), 239.0)
    }
    
    func testGetSingleProduct() {
        let viewModel = ProductsViewModel(with: nil)
        viewModel.updateProduct(response: products)
        
        XCTAssertEqual(viewModel.getSingleProduct(index: 0).id, 1)
        XCTAssertEqual(viewModel.getSingleProduct(index: 0).productName, "first product")
        XCTAssertEqual(viewModel.getSingleProduct(index: 0).productDescription, "A random first product")
        XCTAssertEqual(viewModel.getSingleProduct(index: 0).image.width, 200)
        XCTAssertEqual(viewModel.getSingleProduct(index: 0).image.height, 215)
        XCTAssertEqual(viewModel.getSingleProduct(index: 0).image.url, "a url")
        XCTAssertEqual(viewModel.getSingleProduct(index: 0).price, 234)
        
        XCTAssertEqual(viewModel.getSingleProduct(index: 1).id, 2)
        XCTAssertEqual(viewModel.getSingleProduct(index: 1).productName, "second product")
        XCTAssertEqual(viewModel.getSingleProduct(index: 1).productDescription, "A random second product")
        XCTAssertEqual(viewModel.getSingleProduct(index: 1).image.width, 180)
        XCTAssertEqual(viewModel.getSingleProduct(index: 1).image.height, 200)
        XCTAssertEqual(viewModel.getSingleProduct(index: 1).image.url, "a second url")
        XCTAssertEqual(viewModel.getSingleProduct(index: 1).price, 200)
    }
    
    

}
