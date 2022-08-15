//
//  Loader.swift
//  GiphyDiary
//
//  Created by Akanksha Garg on 15/08/22.
//

import UIKit

class Loader {
    var activityIndicator: UIActivityIndicatorView?
    var parentView: UIView?
    
    /// Initializer
    ///
    /// - Parameters:
    ///   - view: view on which loader needs to be displayed.
    ///   - style: loader style.
    init(view: UIView?, style: UIActivityIndicatorView.Style) {
        parentView = view
        activityIndicator = UIActivityIndicatorView(style: style)
        activityIndicator?.center = parentView?.center ?? CGPoint.zero
        activityIndicator?.color = UIColor.black
    }
    
    /// To start showing loader.
    internal func start() {
        DispatchQueue.main.async {
            self.activityIndicator?.startAnimating()
            if let activity = self.activityIndicator {
                self.parentView?.addSubview(activity)
            }
        }
    }
    
    /// To stop showing loader.
    internal func stop() {
        DispatchQueue.main.async {
            self.activityIndicator?.stopAnimating()
            self.activityIndicator?.removeFromSuperview()
        }
    }
}
