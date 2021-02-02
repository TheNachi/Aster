//
//  ApiConfig+Cache.swift
//  Aster
//
//  Created by Munachimso Ugorji on 02/02/2021.
//

import Foundation
import SystemConfiguration

struct ApiConfig {
    static let baseURL: String = "https://aster.getsandbox.com/products"
}

public class Reachability {
    
    class func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0,
                                      sin_port: 0, sin_addr: in_addr(s_addr: 0),
                                      sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }
        
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        let ret = (isReachable && !needsConnection)
        return ret
        
    }
}

class CacheManager {
    public static let shared = CacheManager()
    public static var inMemoryCache: [String: Any?] = [:]
    public static var inMemoryArrayCache: [String: [Any?]] = [:]
    
    func cacheString(with key: String, data: String) {
        guard !key.isEmpty else { return }
        let currentDataInRam = CacheManager.inMemoryCache[key] as? String
        CacheManager.inMemoryCache[key] = data
        if (currentDataInRam != data) {
            saveToFile(with: key, text: data)
        }
    }
    
    func loadCachedString(with key: String) -> String? {
        guard !key.isEmpty else { return nil }
        if let inmemory = CacheManager.inMemoryCache[key] as? String {
            return inmemory
        } else {
            return readFromFile(with: key)
        }
    }
    
    private func saveToFile(with key: String, text: String) {
        let fileName = "\(key).json"
        if let dir = CacheManager.getFileUrl(with: fileName) {
            do {
                try text.write(to: dir, atomically: true, encoding: .utf8)
            } catch {
                print("Failed to write to file \(fileName)")
            }
        }
    }
    
    private static func getFileUrl(with fileName: String) -> URL? {
        let baseUrl = FileManager.default.urls(for: .cachesDirectory,
            in: .userDomainMask).first
        return baseUrl?.appendingPathComponent(fileName)
    }
    
    private func readFromFile(with key: String) -> String? {
        let fileName = "\(key).json"
        guard let url = CacheManager.getFileUrl(with: fileName) else { return nil }
        do {
            return try String(contentsOf: url, encoding: .utf8)
        } catch {
            return nil
        }
    }
}
