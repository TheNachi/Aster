//
//  ProductDetailsViewModel.swift
//  Aster
//
//  Created by Munachimso Ugorji on 02/02/2021.
//

import Foundation

import Foundation

struct ProductDetailsViewModel {
    private var product: ProductModel
    
    init(with product: ProductModel) {
        self.product = product
    }
    
    func getProductUrl() -> String {
        return self.product.image.url
    }
    
    func getProductDescription() -> String {
        return self.product.productDescription
    }
    
    func getProductPrice() -> String {
        return "$\(self.product.price)"
    }
}
