//
//  ProductModels.swift
//  Aster
//
//  Created by Munachimso Ugorji on 02/02/2021.
//

import UIKit

struct ProductModel: Decodable {
    let id: Int
    let productName: String
    let productDescription: String
    let image: ImageModel
    let price: Int
}

struct ImageModel: Decodable {
    let width: Int
    let height: Int
    let url: String
    
    var aspectRatio: CGFloat {
        return CGFloat(width) / CGFloat(height)
    }
}
