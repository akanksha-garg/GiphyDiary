//
//  ImagesCollectionViewCell.swift
//  GiphyDiary
//
//  Created by Akanksha Garg on 13/08/22.
//

import UIKit

protocol ImagesCollectionViewCellDelegate: AnyObject {
    func unFavActionOn(cell: ImagesCollectionViewCell)
}

class ImagesCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var img: UIImageView!
    var delegate: ImagesCollectionViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = UIColor.systemGray4
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.systemGray3.cgColor
        // Initialization code
    }
    
    // MARK: - IBActions
    
    @IBAction func unFavButtonAction(_ sender: Any) {
        delegate?.unFavActionOn(cell: self)
    }
}
