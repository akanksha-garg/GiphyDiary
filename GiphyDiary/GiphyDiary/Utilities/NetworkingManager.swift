//
//  NetworkingManager.swift
//  GiphyDiary
//
//  Created by Akanksha Garg on 15/08/22.
//

import Foundation
import Reachability

/// Enum to return specific error message
enum JsonError: Error, CustomStringConvertible {
    
    case serviceError
    case noDataError
    case notFound
    case noNetwork
    
    public var description: String {
        switch self {
        case .serviceError:
            return Constants.Error.serviceError
        case .noDataError:
            return Constants.Error.noDataError
        case .notFound:
            return Constants.Error.notFoundError
        case .noNetwork:
            return Constants.Error.noNetwork
        }
    }
}

/// This class is used for making network calls
class NetworkingManager: NetworkingProtocol {
            
    /// - parameter apiURL: Api url
    /// - parameter onCompletion: Returns flag for api success, response header and response data
    func callGetAPI(apiURL: String, requestData: [String: String]?, onCompletion:  @escaping (Result<Data, Error>) -> Void) {
        
        do {
            guard try Reachability().connection != .unavailable else {
                onCompletion(.failure(JsonError.noNetwork))
                return
            }
        } catch {
            debugPrint(Constants.Error.reachabilityError)
            onCompletion(.failure(JsonError.noNetwork))
            return
        }
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        // Adding Query Params to URL if any.
        if let urlComponents = NSURLComponents(string: apiURL) {
            urlComponents.queryItems = [URLQueryItem]()
            if let paramData = requestData {
                for (key, value) in paramData {
                    let queryItem = URLQueryItem(name: key, value: value)
                    urlComponents.queryItems?.append(queryItem)
                }
            }
            
            guard let url = urlComponents.url else {
                onCompletion(.failure(JsonError.notFound))
                return
            }
            debugPrint("=======================================")
            debugPrint("Request URL: ", url)
            
            let task = session.dataTask(with: url) { (data, _, error) in
                
                // Ensure there is no error for this HTTP response
                guard error == nil else {
                    debugPrint("Response Error: ", error!.localizedDescription)
                    debugPrint("=======================================")
                    onCompletion(.failure(JsonError.serviceError))
                    return
                }
                // Ensure there is data returned from this HTTP response
                guard let content = data else {
                    onCompletion(.failure(JsonError.noDataError))
                    return
                }
                debugPrint("Response Data: ", NSString(data: content, encoding: String.Encoding.utf8.rawValue) ?? "")
                debugPrint("=======================================")
                onCompletion(.success(content))
            }
            task.resume()
        } else {
            onCompletion(.failure(JsonError.notFound))
        }
    }
}
