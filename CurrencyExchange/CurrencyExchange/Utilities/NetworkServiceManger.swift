//
//  NetworkServiceManger.swift
//  CurrencyExchange
//
//  Created by Nikunj Modi on 19/11/22.
//

import Foundation
class NetworkServiceManger {
    static let shared: NetworkServiceManger = NetworkServiceManger()
    
    public func infoForKey(_ key: String) -> String? {
            return (Bundle.main.infoDictionary?[key] as? String)?
                .replacingOccurrences(of: "\\", with: "")
    }
    
    private var baseURL: URL {
            return URL(string: infoForKey("BaseUrl")!)!
    }
}

enum NetworkError: Error {
    case invalidURL(String)
    case invalidResponse(String)
    case decodingError(String)
    case genericError(String)
    case internetError(String)
    
}
