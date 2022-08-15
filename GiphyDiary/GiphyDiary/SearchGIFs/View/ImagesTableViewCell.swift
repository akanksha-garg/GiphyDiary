//
//  ImagesTableViewCell.swift
//  GiphyDiary
//
//  Created by Akanksha Garg on 15/08/22.
//

import UIKit

protocol ImagesTableViewCellDelegate: AnyObject {
    func unFavActionOn(cell: ImagesTableViewCell)
}

class ImagesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var favtImgView: UIImageView!
    @IBOutlet weak var favtButton: UIButton!
    
    var delegate: ImagesTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        img.animationImages?.removeAll()
        img.stopAnimating()
        img.image = UIImage(named: Constants.Image.placeHolder)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    // MARK: - IBActions
    
    @IBAction func unFavButtonAction(_ sender: Any) {
        delegate?.unFavActionOn(cell: self)
    }
    
    // MARK: - Instance Methods

    /// Set dynamic data on Cell
    ///
    /// - Parameters:
    ///   - data: Giphy data to be displayed on cell
    func configure(_ data: GiphyData) {
        
        favtImgView.image = (data.isFavorite) ? UIImage(systemName: Constants.Image.fav):UIImage(systemName: Constants.Image.unFav)
        guard let url = URL(string: data.images?.downsized?.url ?? "") else {
            setNoDataViewOn()
            return
        }
        img.loadGIF(url, data.id)
    }
    
    /// Changes that need to be done when there is no data.
    
    private func setNoDataViewOn() {
        favtImgView.isHidden = true
        favtButton.isHidden = true
    }

}
