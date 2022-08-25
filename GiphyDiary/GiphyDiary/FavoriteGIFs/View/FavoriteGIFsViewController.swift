//
//  FavoriteGIFsViewController.swift
//  GiphyDiary
//
//  Created by Akanksha Garg on 15/08/22.
//

import UIKit

enum LayoutType {
    case grid
    case list
}

class FavoriteGIFsViewController: UIViewController {
    
    @IBOutlet weak var imagesCollectionview: UICollectionView!
    @IBOutlet var segmentedControl: UISegmentedControl!
    
    /// Brain of FavoriteGIFsViewController: ViewModel object for all business logics.
    var viewModel = FavoriteGIFsViewModel()
    ///Padding between the cells
    private let padding = 8.0
    ///To show large cell on first position on alternate rows.
    var isAlternate = false
    ///Currently selected display type.
    var selectedType:LayoutType = .grid
    /// Loder for showing loading while we get response from service
    private var loader: Loader?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        intialSetup()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        loader?.start()
        viewModel.getAllImageInFavoriteFolder(){ [weak self] (success, error) in
            DispatchQueue.main.async {
                self?.loader?.stop()
                if success {
                    self?.imagesCollectionview.reloadData()
                } else if let error =  error as? JsonError {
                    print(error.localizedDescription)
                }
            }
        }
       
    }
    
    // MARK: - Instance Methods
    
    /// Intial setup UI elements.
    func intialSetup() {
        imagesCollectionview.register(UINib(nibName: Constants.Identifiers.IMAGES_COLLECTION_VIEW_CELL, bundle: .main), forCellWithReuseIdentifier: Constants.Identifiers.IMAGES_COLLECTION_VIEW_CELL)
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
        layout.minimumInteritemSpacing = padding
        layout.minimumLineSpacing = 10.0
        imagesCollectionview.collectionViewLayout = layout
        imagesCollectionview.delegate = self
        segmentedControl.addTarget(self, action: #selector(FavoriteGIFsViewController.indexChanged(_:)), for: .valueChanged)
        loader = Loader(view: view, style: .large)
    }
    
    /// SegmentBar change action.
    @objc func indexChanged(_ sender: UISegmentedControl) {
        if segmentedControl.selectedSegmentIndex == 0 {
            print("Select 0")
            selectedType = .grid
        } else if segmentedControl.selectedSegmentIndex == 1 {
            selectedType = .list
            print("Select 1")
        }
        imagesCollectionview.reloadData()
        scrollToTop()
    }
    
    /// To scroll down table to first row.
    private func scrollToTop() {
        imagesCollectionview.setContentOffset(CGPoint(x:0,y:0), animated: true)
    }
}

// MARK: - Extension for CollectionView Delegate and Datasource
extension FavoriteGIFsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let favCount = viewModel.favoriteImage?.count ?? 0
        if favCount == 0 {
            collectionView.setEmptyMessage("There's so much space in here! \n\n It could be filled with your Favorite GIFs.")
        } else {
            collectionView.restore()
        }
        return favCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.Identifiers.IMAGES_COLLECTION_VIEW_CELL, for: indexPath) as? ImagesCollectionViewCell else { return UICollectionViewCell() }
        cell.img.image = viewModel.favoriteImage?[indexPath.item]
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.bounds.width
        let height = collectionView.bounds.height/4
        
        if selectedType == .list {
            return CGSize(width: width, height: height*1.5)
        }
        let x = (width-(padding*2.0))/3.0
        var newWidth = x
        let newIndexValue = indexPath.item-3 //To make Starting 3 cells to be of same size.
        if newIndexValue >= 0 {
            if (!isAlternate && newIndexValue % 5 == 0) || (isAlternate && newIndexValue % 5 == 1) {
                // Show large cell
                newWidth = (2.0*x)+padding
            } else if newIndexValue % 5 == 2 {
                //As we enter the row with 3 cells, update the "isAlternate" value.
                isAlternate = !isAlternate
            }
        }
        return CGSize(width: newWidth, height: height)
    }
}

// MARK: - Extension for CollectionViewCell Delegate
extension FavoriteGIFsViewController: ImagesCollectionViewCellDelegate {
    
    func unFavActionOn(cell: ImagesCollectionViewCell) {
        guard let indexPath = imagesCollectionview?.indexPath(for: cell) else {return}
        var name = viewModel.favoriteImageNames?[indexPath.item] ?? ""
        //Removing .extension part from the image name
        name.removeLast(4)
        viewModel.removeImageFromFavoriteFolder(imageName: name, index: indexPath.item){ [weak self] (success, error) in
            DispatchQueue.main.async {
                self?.loader?.stop()
                if success {
                    self?.imagesCollectionview.deleteItems(at: [indexPath])
                } else if let error =  error as? JsonError {
                    print(error.localizedDescription)
                }
            }
        }
    }
}
