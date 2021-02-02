//
//  ProductsViewModel.swift
//  Aster
//
//  Created by Munachimso Ugorji on 02/02/2021.
//

import UIKit

class ProductsViewModel {
    var apiService: ApiService?
    var products: [ProductModel] = []
    weak var delegate: ProductsViewDelegate?
    
    init(with apiService: ApiService?) {
        self.apiService = apiService
        self.apiService?.delegate = self
    }

    public func getProducts(with count: String, noOfPages: String) {
        guard let apiService = self.apiService else { return }
        apiService.getProduct(with: count, noOfPages: noOfPages)
    }
    
    public func getProductsCount() -> Int {
        return self.products.count
    }
    
    public func updateProduct(response: [ProductModel]) {
        products.append(contentsOf: response)
    }
    
    public func getImageHeightFor(width: CGFloat, at index: Int) -> CGFloat {
        let aspectRatio = CGFloat(self.products[index].image.width) / CGFloat(self.products[index].image.height)
        let imageHeight = width / aspectRatio
    
        let attString = NSAttributedString(string: self.products[index].productDescription, attributes: [.font : UIFont.systemFont(ofSize: 16)])
        
        return attString.height(containerWidth: width) + imageHeight
    }
    
    public func getSingleProduct(index: Int) -> ProductModel {
        return self.products[index]
    }
    
    public func getProductCellViewModel(index: Int) -> ProductCellViewModel {
        return ProductCellViewModel(with: self.getSingleProduct(index: index))
    }
}

extension ProductsViewModel: ProductDelegate {
    func onGetProduct(response: [ProductModel]) {
        self.updateProduct(response: response)
        self.delegate?.productLoaded()
    }
    
    func onFail() {
    }

}

protocol ProductsViewDelegate: class {
    func productLoaded()
    func gotError(error: Error)
}
