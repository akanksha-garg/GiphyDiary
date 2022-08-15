//
//  FavoriteGIFsViewModel.swift
//  GiphyDiary
//
//  Created by Akanksha Garg on 15/08/22.
//

import Foundation
import UIKit

class FavoriteGIFsViewModel {
    
    /// Shared instance of our Local file Manager.
    private let fileManager = LocalFileManager.instance
    /// GIFs that are saved as favorite.
    var favoriteImage: [UIImage]?
    /// GIFs names array that are saved as favorite.
    var favoriteImageNames: [String]?
    
    
    internal func getAllImageInFavoriteFolder() {
        let (images, imageNames) = fileManager.getAllImagesIn(folderName: Constants.Data.folderName)
        favoriteImage = images
        favoriteImageNames = imageNames
    }
    
    
    internal func removeImageFromFavoriteFolder(imageName: String, index: Int) {
        let success = fileManager.removeImage(imageName: imageName, folderName: Constants.Data.folderName)
        if success {
            favoriteImage?.remove(at: index)
            favoriteImageNames?.remove(at: index)
        }
    }
}
