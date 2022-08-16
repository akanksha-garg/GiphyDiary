//
//  SearchGifsViewController.swift
//  GiphyDiary
//
//  Created by Akanksha Garg on 15/08/22.
//

import UIKit

class SearchGifsViewController: UIViewController {
    
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    /// Brain of SearchGifsViewController: ViewModel object for all business logics.
    fileprivate var viewModel = SearchGifsViewModel()
    /// Loder for showing loading while we get response from service
    private var loader: Loader?
    /// Message for showing error if we get any from API service.
    private var backgroundInfoMessage = Constants.Text.searchingMessage
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchTrendingGiphy(keyword: "")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        performAfterCancelSearch()
    }
    
    // MARK: - Instance Methods
    
    /// Intial setup UI elements and ViewModel.
    private func initialSetup() {
        searchBar.delegate = self
        tblView.delegate = self
        tblView.dataSource = self
        tblView.register(UINib(nibName: Constants.Identifiers.IMAGES_TABLEVIEW_CELL, bundle: nil), forCellReuseIdentifier: Constants.Identifiers.IMAGES_TABLEVIEW_CELL)
        loader = Loader(view: view, style: .large)
    }
    
    /// Fetch and display GIF data from JSON file.
    ///
    /// - Parameter keyword: keyword for searching related GIFs.
    private func fetchTrendingGiphy(keyword: String) {
        if Constants.Data.giphyAPI_Key == "" {
            backgroundInfoMessage = Constants.Error.noKeyFound
            return
        }
        loader?.start()
        viewModel.fetchTrendingGiphy(keyword: keyword){ [weak self] (success, error) in
            DispatchQueue.main.async {
                self?.loader?.stop()
                if success {
                    if let giphyCount = self?.viewModel.getCurrentGiphyCount(), giphyCount == 0 {
                        self?.backgroundInfoMessage = Constants.Text.noResultFoundMessage
                    }
                    self?.tblView.reloadData()
                } else if let error =  error as? JsonError{
                    self?.backgroundInfoMessage = error.description
                }
            }
        }
    }
    
    /// To show Error banner if an error occured while fetching data.
    private func showErrorBannerOnBackground() {
        let tempImageView = UIImageView(image: UIImage(named: Constants.Image.errorBanner))
        tempImageView.contentMode = .scaleAspectFit
        tempImageView.frame = tblView.frame
        tblView.backgroundView = tempImageView
    }
    
    /// To scroll down table to first row.
    private func scrollTableToTop() {
        tblView.setContentOffset(CGPoint(x:0,y:0), animated: true)
    }
    
    /// To refresh serachbar and tableview once search is completed/cancelled.
    private func performAfterCancelSearch() {
        searchBar.resignFirstResponder()
        viewModel.searching = false
        searchBar.text = ""
        tblView.reloadData()
        scrollTableToTop()
    }
}

// MARK: - Extension for TableView Delegate and Datasource

extension SearchGifsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let giphyCount = viewModel.getCurrentGiphyCount()
        if giphyCount == 0 {
            tableView.setEmptyMessage(backgroundInfoMessage)
        } else {
            tableView.restore()
        }
        return giphyCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Identifiers.IMAGES_TABLEVIEW_CELL, for: indexPath) as? ImagesTableViewCell else { return UITableViewCell()
        }
        // Set Data on cell
        cell.delegate = self
        cell.tag = indexPath.row
        let giphyData = viewModel.getCurrentGiphyData()
        guard let giphy = giphyData?[indexPath.row] else {return cell}
        cell.configure(giphy)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
}

// MARK: - Extension for Searchbar Delegate
extension SearchGifsViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let trimmedString = searchBar.text?.trimmingCharacters(in: .whitespaces)
        guard trimmedString != "" else {return}
        searchBar.resignFirstResponder()
        viewModel.searching = true
        fetchTrendingGiphy(keyword: searchBar.text ?? "")
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        performAfterCancelSearch()
    }
}

// MARK: - Extension for TableViewCell Delegate
extension SearchGifsViewController: ImagesTableViewCellDelegate {
    
    func unFavActionOn(cell: ImagesTableViewCell) {
        if let currentGiphy = viewModel.giphys?.giphyData[cell.tag] {
            if currentGiphy.isFavorite {
                viewModel.removeImageFromFavoriteFolder(imageName: currentGiphy.id){(success, error) in
                    DispatchQueue.main.async {
                        if success {
                            currentGiphy.isFavorite = false
                            cell.favtImgView.image = UIImage(systemName: Constants.Image.unFav)
                        }
                    }
                }
            } else {
                if let image = cell.img.animationImages, image.count > 0 {
                    viewModel.saveImageInFavoriteFolder(image: image[0], imageName: currentGiphy.id) {(success, error) in
                        DispatchQueue.main.async {
                            if success {
                                currentGiphy.isFavorite = true
                                cell.favtImgView.image = UIImage(systemName: Constants.Image.fav)
                            }
                        }
                    }
                }
            }
        }
    }
}
