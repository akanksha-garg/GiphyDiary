//
//  Constants.swift
//  GiphyDiary
//
//  Created by Akanksha Garg on 15/08/22.
//

import Foundation

/// Type of identifier for completion of fetch data service call.
typealias fetchDataCompletionHandler = (Bool, Error?) -> Void

/// To organize app’s important data and resources, such as API urls, errors, colors, images, strings, URLs, etc.
struct Constants {
    
    struct Data {
        //ToDo: Replace this with your account sepcific GIPHY API key
        static let giphyAPI_Key = ""  //for example: "EwyL193ETNigSUt0k14PwpEPZiDwAqAm"
        static let folderName = "MyFavorites"
    }
    
    struct API {
        static let baseURL = "https://api.giphy.com/v1/gifs"
        static let trendingGiphyAPI = "/trending"
        static let searchGiphyAPI = "/search"
    }
    
    struct Error {
        static let serviceError = "There is some problem in fetching the data."
        static let noDataError = "No Data Found."
        static let notFoundError = "Invalid URL."
        static let noNetwork = "Internet connection is not available."
        static let inValidJSONError = "Couldn't parse JSON: %@"
        static let errorTitle = "Error!!!"
        static let reachabilityError = "could not start reachability notifier"
        static let noKeyFound = "No API key found in request."
    }
    
    struct Text {
        static let ok = "OK"
        static let searchingMessage = "Searching for trending GIFs..."
        static let noResultFoundMessage = "No results found. Please search using other keywords."
    }
    
    struct Image {
        static let errorBanner = "ErrorBanner"
        static let placeHolder = "placeholder_image"
        static let fav = "heart.fill"
        static let unFav = "heart"
    }
    
    struct Identifiers {
        static let IMAGES_TABLEVIEW_CELL = "ImagesTableViewCell"
        static let IMAGES_COLLECTION_VIEW_CELL = "ImagesCollectionViewCell"
        static let SEARCH_GIF_CONTROLLER = "SearchGifsViewController"
        static let FAVORITE_GIF_CONTROLLER = "FavoriteGIFsViewController"
        static let MAIN_STORYBOARD = "Main"
    }

}
