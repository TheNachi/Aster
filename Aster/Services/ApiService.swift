//
//  ApiService.swift
//  Aster
//
//  Created by Munachimso Ugorji on 02/02/2021.
//

import Foundation

struct ApiService {
    private let productURL = ApiConfig.baseURL
    private let productsCache = ProductsCache()
    weak var delegate: ProductDelegate?
    
    func getProduct(with count: String, noOfPages: String) {
        if (Reachability.isConnectedToNetwork()) {
            if let url = URL(string: "\(productURL)?count=\(count)&from=\(noOfPages)") {
                let session = URLSession(configuration: .default)
                let task = session.dataTask(with: url) { (data, response, error) in
                    if error != nil {
                        print(error!)
                        return
                    }
                    
                    if let productData = data {
                        self.parseJSON(productData: productData)
                    }
                }
                task.resume()
            }
        } else {
            self.productsCache.loadFromCache(delegate: delegate)
        }
    }
    
    func parseJSON(productData: Data) {
        let stringValue = productData.base64EncodedString()
        let decoder = JSONDecoder()
        do {
            let data = try decoder.decode([ProductModel].self, from: productData)
            delegate?.onGetProduct(response: data)
            CacheManager.inMemoryArrayCache.updateValue(data, forKey: CacheKeys.products.rawValue)
            CacheManager.shared.cacheString(with: CacheKeys.products.rawValue, data: stringValue)
        } catch {
            print(error)
        }
    }
}

struct ProductsCache {
    
    func loadFromCache(delegate: ProductDelegate?) {
        DispatchQueue.main.async {
            if let inMemoryProduct = CacheManager.inMemoryCache[CacheKeys.products.rawValue] as? [ProductModel] {
                delegate?.onGetProduct(response: inMemoryProduct)
            } else {
                if let cachedProducts = CacheManager.shared.loadCachedString(with: CacheKeys.products.rawValue) {
                    if let cachedData = Data(base64Encoded: cachedProducts) {
                        let decoder = JSONDecoder()
                        do {
                            let data = try decoder.decode([ProductModel].self, from: cachedData)
                            delegate?.onGetProduct(response: data)
                        } catch {
                            print(error)
                        }
                    }
                }
            }
        }
    }
}

protocol ProductDelegate: class {
    func onGetProduct(response: [ProductModel])
    func onFail()
}

enum CacheKeys: String {
    case products
}
