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
    
    ///To get all the images currently favorite by user.
    func getAllImageInFavoriteFolder() {
        let (images, imageNames) = fileManager.getAllImagesIn(folderName: Constants.Data.folderName)
        favoriteImage = images
        favoriteImageNames = imageNames
    }
    
    ///To remove image from favorites.
    func removeImageFromFavoriteFolder(imageName: String, index: Int) {
       fileManager.removeImage(imageName: imageName, folderName: Constants.Data.folderName){ [weak self] (success, error) in
            DispatchQueue.main.async {
                if success {
                    self?.favoriteImage?.remove(at: index)
                    self?.favoriteImageNames?.remove(at: index)
                }
            }
        }
    }
}
