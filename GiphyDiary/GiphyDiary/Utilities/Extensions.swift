//
//  Extensions.swift
//  GiphyDiary
//
//  Created by Akanksha Garg on 16/08/22.
//


import Foundation
import UIKit

var imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    
    /// Download GIF from given url and convert it to array of Images.
    ///
    /// - Parameters:
    ///   - url: Path from where GIF needs to be downloaded.
    
    func loadGIF(_ url: URL, _ uniqueID: String) {
        
        // Check and return if GIF is avaialble in cache.
        if let images = imageCache.object(forKey: uniqueID as NSString) as? [UIImage] {
            self.animationImages = images
            self.startAnimating()
            return
        }
        
        //If GIF is not avaialble in cache, then download.
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, let source =  CGImageSourceCreateWithData(data as CFData, nil)
            else {
                //Failure
                DispatchQueue.main.async {
                    self.image = UIImage(named: Constants.Image.placeHolder)
                }
                return
            }
            let imageCount = CGImageSourceGetCount(source)
            var images = [UIImage]()
            for i in 0 ..< imageCount {
                if let image = CGImageSourceCreateImageAtIndex(source, i, nil) {
                    images.append(UIImage(cgImage: image))
                }
            }
            //Success: Saving GIF in cache.
            DispatchQueue.main.async { [weak self] in
                imageCache.setObject(images as AnyObject, forKey: uniqueID as NSString)
                self?.animationImages = images
                self?.startAnimating()
            }
        }
        task.resume()
    }
    
    /// Download JPEG/PNG from given url and convert it to Image object.
    ///
    /// - Parameters:
    ///   - url: Path from where image needs to be downloaded.
    
    func loadImage(_ url: URL, _ uniqueID: String) {
        
        // Check and return if image is avaialble in cache.
        if let image = imageCache.object(forKey: uniqueID as NSString) as? UIImage {
            self.image = image
            return
        }
        //If Image is not avaialble in cache, then download.
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, let image = UIImage(data: data)
            else {
                //Failure
                DispatchQueue.main.async {
                    self.image = UIImage(named: Constants.Image.placeHolder)
                }
                return
                
            }
            //Success: Saving image in cache.
            DispatchQueue.main.async { [weak self] in
                imageCache.setObject(image, forKey: uniqueID as NSString)
                self?.image = image
            }
        }
        task.resume()
    }
}

extension UICollectionView {
    
    /// To set some message on background, can be used when we have empty data list.
    ///
    /// - Parameter message: Message to be shown in collection view background.
    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.sizeToFit()
        self.backgroundView = messageLabel
    }
    
    /// To cleanup the background view.
    func restore() {
        self.backgroundView = nil
    }
}


extension UITableView {
    
    /// To set some message on background, can be used when we have empty data list.
    ///
    /// - Parameter message: Message to be shown in tableview background.
    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.sizeToFit()
        
        self.backgroundView = messageLabel
        self.separatorStyle = .none
    }
    
    /// To cleanup the background view.
    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
}

extension NSObject {
    
    ///To read JSON file
    func readjson(fileName: String) -> Data? {
        do {
            if let url = Bundle.main.path(forResource: fileName, ofType: "json") {
                let path = URL(fileURLWithPath:url)
                let data = try Data(contentsOf: path)
                return data
            } else {
                print(Constants.Error.noDataError)
            }
        }
        catch {
            print(error.localizedDescription)
        }
        return nil
    }
}

