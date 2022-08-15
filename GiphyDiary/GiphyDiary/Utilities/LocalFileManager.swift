//
//  LocalFileManager.swift
//  GiphyDiary
//
//  Created by Akanksha Garg on 15/08/22.
//

import Foundation
import UIKit

class LocalFileManager {
    
    /// Shared Instance
    static let instance = LocalFileManager()
    
    /// Initializer
    private init() {}
    
    
    /// Save the image in Document directory at specified folder through File Manager.
    ///
    /// - Parameters:
    ///   - image: Image that need to be saved.
    ///   - imageName: Name from which image need to be saved.
    ///   - folderName: Name of folder in which image need to be saved.
    
    func saveImage(image: UIImage, imageName: String, folderName: String, _ completion: @escaping (Bool,Error?) -> Void) {
        
        //Step1-> Create Folder.
        createFolderIfNeeded(folderName: folderName)
        
        //Step2-> Get path for Image.
        guard
            let data = image.pngData(),
            let url = getURLForImage(imageName: imageName, folderName: folderName)
        else {
            completion(false, nil)
            return }
        //Step3-> Save Image to path.
        DispatchQueue.global().async {
            do {
                try data.write(to: url)
                completion(true, nil)
            } catch let error {
                print("Error saving image. \(error)")
                completion(false, error)
            }
        }
    }
    
    /// Remove the data in Document directory at specified path through File Manager.
    ///
    /// - Parameters:
    ///   - imageName: Name from which image need to be removed.
    ///   - folderName: Name of folder from which image need to be removed.
    ///
    /// - returns: Status of Operation (Wether Success or Failure).
    
    func removeImage(imageName: String, folderName: String) -> Bool {
        
        //Step1-> Get path for image.
        guard let url = getURLForImage(imageName: imageName, folderName: folderName) else {return false}
        //Step2-> Remove image on on fetched path.
        do {
            try FileManager.default.removeItem(atPath: url.path)
        } catch let error {
            print("Error removing image. \(error)")
            return false
        }
        return true
    }
    
    /// Fetch the image from specified path through File Manager.
    ///
    /// - Parameters:
    ///   - imageName: Name of image that need to be fetched.
    ///   - folderName: Name of folder from which image need to be fetched.
    ///
    /// - returns: Image fetched from given folder.
    
    func getImage(imageName:String, folderName: String) -> UIImage? {
        
        guard
            let url = getURLForImage(imageName: imageName, folderName: folderName),
            FileManager.default.fileExists(atPath: url.path) else {return nil}
        return UIImage(contentsOfFile: url.path)
    }
    
    /// Fetch all the images from specified path through File Manager.
    ///
    /// - Parameters:
    ///   - folderName: Name of folder from which images need to be fetched.
    ///
    ///  - returns: Images and their Names arary fetched from given folder.
    
    func getAllImagesIn(folderName: String) -> ([UIImage]?, [String]?) {
        
        guard let url = getURLForFolder(folderName: folderName) else {return (nil,nil)}
        
        
        do {
            let images = try FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: [.contentModificationDateKey], options: .skipsHiddenFiles)
            let imagesNamesArray = images.map { image in
                (image.lastPathComponent, (try? image.resourceValues(forKeys: [.contentModificationDateKey]))?.contentModificationDate ?? Date.distantPast)
            }
                .sorted(by: { $0.1 > $1.1 }) // sort descending modification dates
                .map { $0.0 }
            
            var imageArray = [UIImage]()
            for value in imagesNamesArray {
                if let image = UIImage(contentsOfFile: (url.path+"/"+value)) {
                    imageArray.insert(image, at: 0)
                }
            }
            return (imageArray, imagesNamesArray)
            
            
        } catch let error {
            print("Error while Fetching data from folder. FolderName: \(folderName). \(error)")
            return (nil, nil)
        }
    }
    
    /// Create Folder in Document directory if it does not exist already.
    ///
    /// - Parameters:
    ///   - folderName: Name of folder that need to be created.
    
    private func createFolderIfNeeded(folderName: String) {
        
        guard let url = getURLForFolder(folderName: folderName) else {return}
        if !FileManager.default.fileExists(atPath: url.path) {
            do {
                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
            } catch let error {
                print("Error creating Directory. FolderName: \(folderName). \(error)")
            }
        }
    }
    
    /// To get path of particlar folder in document directory/File System.
    ///
    /// - Parameters:
    ///   - folderName: Folder who's path need to be returned.
    ///
    ///  - returns: URL of folder in document directory.
    
    private func getURLForFolder(folderName: String) -> URL? {
        
        guard let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            return nil
        }
        return url.appendingPathComponent(folderName)
    }
    
    /// To get url path at which of particlar image is saved in document directory/File System.
    ///
    /// - Parameters:
    ///  - imageName: Image who's path need to be fetched.
    ///  - folderName: Folder in which image is saved.
    ///
    ///  - returns: Images and their Names arary fetched from given folder.
    
    private func getURLForImage(imageName: String, folderName: String) -> URL? {
        
        guard let folderURL = getURLForFolder(folderName: folderName) else {
            return nil
        }
        return folderURL.appendingPathComponent(imageName + ".png")
    }
    
}
