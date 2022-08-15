//
//  SearchGifsViewModel.swift
//  GiphyDiary
//
//  Created by Akanksha Garg on 15/08/22.
//

import Foundation
import UIKit

class SearchGifsViewModel {
    
    // MARK: - Properties
    ///GIFs Data
    var giphys: Giphy?
    
    /// Error recieved from Network call
    var serviceError: JsonError?
    
    ///GIFs Data from search
    var searchedGiphys: Giphy?
    
    ///To check whether search is enabled currently.
    var searching = false
    
    ///Network manager instance,
    private var apiService: NetworkingProtocol = NetworkingManager()
    
    ///Shared instance of file Manager.
    private let fileManager = LocalFileManager.instance
    
    internal func fetchTrendingGiphy(keyword: String = "",_ completion: fetchDataCompletionHandler?) {
        
        let trendingUrl = searching ? (Constants.API.baseURL + Constants.API.searchGiphyAPI):(Constants.API.baseURL + Constants.API.trendingGiphyAPI)
        var requestData = [
            "api_key": Constants.Data.giphyAPI_Key,
        ]
        if searching {
            requestData["q"] = keyword
        }
        
        apiService.callGetAPI(apiURL: trendingUrl, requestData: requestData) { [weak self] (result)  in
            switch result {
                
            case .success(let data):
                guard let resultData = self?.parse(jsonData: data) else {
                    self?.serviceError = .serviceError
                    completion?(false, JsonError.serviceError)
                    return
                }
                DispatchQueue.main.async {
                    for gif in resultData.giphyData  {
                        if self?.imageExistInFavoriteFolder(imageName: gif.id).1 ?? false {
                            gif.isFavorite = true
                        }
                    }
                    if self?.searching ?? false {
                        self?.searchedGiphys = resultData
                    } else {
                        self?.giphys = resultData
                    }
                    completion?(true, nil)
                }
            case .failure(let error):
                self?.serviceError = error as? JsonError
                completion?(false, error)
            }
        }
    }
    
    /// Save the image at specified folder through Local File Manager.
    ///
    /// - Parameters:
    ///   - image: Image that need to be saved.
    ///   - imageName: Name from which image need to be saved.
    ///
    func saveImageInFavoriteFolder(image: UIImage, imageName: String, _ completion: @escaping (Bool,Error?) -> Void) {
        fileManager.saveImage(image: image, imageName: imageName, folderName: Constants.Data.folderName){ (result, error) in
            completion(result, error)
        }
    }
    
    /// Fetch the image from specified path through Local File Manager.
    ///
    /// - Parameters:
    ///   - imageName: Name of image that need to be fetched.
    ///
    /// - returns: Image fetched from given folder.
    
    func imageExistInFavoriteFolder(imageName: String)-> (UIImage?, Bool) {
        guard let savedImage = fileManager.getImage(imageName: imageName, folderName: Constants.Data.folderName) else {
            return (nil,false)}
        return(savedImage, true)
    }
    
    /// Remove the image at specified path through Local File Manager.
    ///
    /// - Parameters:
    ///   - imageName: Name from which image need to be removed.
    ///   - folderName: Name of folder from which image need to be removed.
    ///
    /// - returns: Status of Operation (Wether Success or Failure).
    
    func removeImageFromFavoriteFolder(imageName: String, index: Int) -> Bool {
        let success = fileManager.removeImage(imageName: imageName, folderName: Constants.Data.folderName)
        return success
    }
    
    ///To find out total number of GIFs available.
    ///
    /// - returns: Count of trending GIFs that need to be displayed.
    
    func getCurrentGiphyCount() -> Int {
        searching ? (searchedGiphys?.giphyData.count ?? 0):(giphys?.giphyData.count ?? 0)
    }
    
    /// To get GIFs data based on check whether Search is enabled.
    ///
    /// - returns:Trending/Searched GIFs data that need to be displayed.
    
    func getCurrentGiphyData() -> [GiphyData]? {
        searching ? (searchedGiphys?.giphyData):(giphys?.giphyData)
    }
}

extension SearchGifsViewModel: ParsingProtocol {
    
    typealias T = Giphy
    /**
     Populate data into DataModels from recieved response.
     
     - parameter jsonData:JSON data  recieved from service call.
     - returns: Model Object
     */
    func parse(jsonData: Data) -> Giphy? {
        do {
            return try JSONDecoder().decode(Giphy.self, from: jsonData)
            
        }   catch {
            debugPrint(Constants.Error.inValidJSONError, "\(error)")
        }
        return nil
    }
}
