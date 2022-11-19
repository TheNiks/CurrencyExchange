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
    
    public func getDataResponse(urlString: String, queryItems: [String: String]? = nil, completionBlock: @escaping (Result<[String: Any], Error>) -> Void) {
        let URL = baseURL.appendingPathComponent(urlString)
        var urlComponents = URLComponents(url: URL, resolvingAgainstBaseURL: false)
        urlComponents?.queryItems = self.getQueryItems(queryItemDictionary: queryItems)
        
        var request = URLRequest(url: (urlComponents?.url)!)
        request.httpMethod = "GET"
        request.addValue(self.infoForKey("APIKey")!, forHTTPHeaderField: StringConstants.apiKey)
        
        guard let _ = urlComponents?.url else {
            completionBlock(.failure(NetworkError.invalidURL("INVALID_URL_ERROR".localized(withComment: "Invalid URL error"))))
            return
        }
        
           let task = URLSession.shared.dataTask(with: request) { data, response, error in
               guard error == nil else {
                   completionBlock(.failure(NetworkError.internetError("NETWORK_ERROR_MESSAGE".localized(withComment: "Network error"))))
                   return
               }
               
               guard let responseData = data else {
                   completionBlock(.failure(NetworkError.genericError("GENERIC_ERROR_MESSAGE".localized(withComment: "Generic error"))))
                   return
               }

               guard let json = (try? JSONSerialization.jsonObject(with: responseData, options: [])) as? [String: AnyObject] else {
                   completionBlock(.failure(NetworkError.decodingError("JSON_DECODING_ERROR_MESSAGE" .localized(withComment: "Decoding error"))))
                   return
               }
               
               guard let httpResponse = response as? HTTPURLResponse,
                   200 ..< 300 ~= httpResponse.statusCode else {
                   completionBlock(.failure(NetworkError.genericError( "GENERIC_ERROR_MESSAGE".localized(withComment: "Generic error"))))
                       return
               }
               
               if let status = json["success"] as? Bool, !status, let errorJson = json["error"] as? [String: Any], let errorMessage = errorJson["info"], let errorString = errorMessage as? String {
                   
                   completionBlock(.failure(NetworkError.invalidResponse(errorString)))
               } else {
                   completionBlock(.success(json))
               }
               
           }
           task.resume()
       }
    
    
    private func getQueryItems(queryItemDictionary: [String: String]?) -> [URLQueryItem] {
        var items = [URLQueryItem]()
        guard let itemDictionary = queryItemDictionary else {
            return items
        }
        for key in itemDictionary.keys {
            items.append(URLQueryItem(name: key, value: itemDictionary[key]))
        }
        
        return items
    }
}

enum NetworkError: Error {
    case invalidURL(String)
    case invalidResponse(String)
    case decodingError(String)
    case genericError(String)
    case internetError(String)
    
}
