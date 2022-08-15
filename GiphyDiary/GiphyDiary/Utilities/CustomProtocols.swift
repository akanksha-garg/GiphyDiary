//
//  CustomProtocols.swift
//  GiphyDiary
//
//  Created by Akanksha Garg on 15/08/22.
//

import Foundation

/// Enum for handling type of response we can get from Server (Mock API response with the help of this.)
enum APIResponseType {
    case success
    case failure
    case invalidUrl
    case noDataError
    case noNetwork
}

/// Protocol to be implemented for parsing data into DataModels from recieved response.
protocol ParsingProtocol {
    associatedtype T
    func parse(jsonData: Data) -> T?
}


/// Protocol to be implemented for making network calls.
protocol NetworkingProtocol {
    func callGetAPI(apiURL: String, requestData: [String: String]?, onCompletion:  @escaping (Result<Data, Error>) -> Void)
}

extension NetworkingProtocol {
    var responseType: APIResponseType? { return .success }
}

