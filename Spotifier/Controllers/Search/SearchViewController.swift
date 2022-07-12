//
//  SearchViewController.swift
//  Spotifier
//
//  Created by Siamak Rostami on 7/11/22.
//

import UIKit
import CoreAudio

class SearchViewController: BaseViewController {
    
    private lazy var viewModel : SearchViewModel = {
       return SearchViewModel()
    }()
    
    private let refreshController = UIRefreshControl()
    
    @IBOutlet weak var searchBar: UISearchBar!{
        didSet{
            searchBar.delegate = self
            searchBar.returnKeyType = .search
        }
    }
    @IBOutlet weak var searchTableView: UITableView!{
        didSet{
            searchTableView.delegate = self
            searchTableView.dataSource = self
            searchTableView.register(UINib(nibName: TrackTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: TrackTableViewCell.identifier)
            searchTableView.register(UINib(nibName: ArtistTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: ArtistTableViewCell.identifier)
            searchTableView.register(UINib(nibName: SearchHeaderTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: SearchHeaderTableViewCell.identifier)
            searchTableView.estimatedRowHeight = 100
            searchTableView.rowHeight = UITableView.automaticDimension
            searchTableView.refreshControl = self.refreshController
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        self.bindError()
        self.bindSearchText()
        self.bindIsLoading()
        self.bindShouldUpdate()
        self.initRefresh()
        // Do any additional setup after loading the view.
    }
    


}

extension SearchViewController {
    
    static func build() -> SearchViewController{
        let controller = AppStoryboard.Search.viewController(viewControllerClass: SearchViewController.self)
        return controller
    }
    
    private func initRefresh(){
        self.refreshController.addTarget(self, action: #selector(refreshView), for: .valueChanged)
    }
    
    @objc private func refreshView(){
        self.viewModel.searchText.send(nil)
        self.viewModel.Search()
    }
    
    
    private func bindError(){
        self.viewModel.error
            .subscribe(on: RunLoop.main)
            .sink { [weak self] error in
                guard let `self` = self else {return}
                guard let error = error else {return}
                self.showError(message: error.errorDescription)
            }
            .store(in: &viewModel.disposeBag)
    }
    private func bindIsLoading(){
        self.viewModel.isLoading
            .subscribe(on: RunLoop.main)
            .sink { [weak self] isLoading in
                guard let `self` = self else {return}
                if isLoading{
                    self.startAnimating()
                }else{
                    self.stopAnimating()
                }
            }
            .store(in: &viewModel.disposeBag)
        
    }
    private func bindShouldUpdate(){
        self.viewModel.shouldUpdateCollection
            .subscribe(on: RunLoop.main)
            .sink { [weak self] shouldUpdate in
                guard let `self` = self else {return}
                guard let shouldUpdate = shouldUpdate else {return}
                if shouldUpdate{
                    self.searchTableView.reloadData()
                }
            }
            .store(in: &viewModel.disposeBag)
    }
    
    private func bindSearchText(){
        self.viewModel.searchText
            .subscribe(on: RunLoop.main)
            .sink { [weak self] search in
                guard let `self` = self else {return}
                self.searchBar.text = search
            }
            .store(in: &viewModel.disposeBag)
        
    }
}

extension SearchViewController : UITableViewDelegate , UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        guard viewModel.searchModel != nil else {
            tableView.setEmptyState(message: nil, image: "magnifyingglass")
            return 0
        }
        tableView.restoreNotificationsState()
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section{
        case 0:
            return viewModel.searchModel?.artists?.items?.count ?? 0
        default:
            return viewModel.searchModel?.tracks?.items?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let model = self.viewModel.searchModel else {return UITableViewCell()}
        switch indexPath.section{
        case 0:
            guard let artist = model.artists else {return UITableViewCell()}
            guard let currentArtist = artist.items else {return UITableViewCell()}
            let current = currentArtist[indexPath.row]
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ArtistTableViewCell.identifier, for: indexPath) as? ArtistTableViewCell else {return UITableViewCell()}
            cell.configureArtistCell(model: current)
            cell.selectionStyle = .none
            return cell
        default:
            guard let tracks = model.tracks else {return UITableViewCell()}
            guard let currentTracks = tracks.items else {return UITableViewCell()}
            let current = currentTracks[indexPath.row]
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TrackTableViewCell.identifier, for: indexPath) as? TrackTableViewCell else {return UITableViewCell()}
            cell.configureTrackCell(model: current)
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableCell(withIdentifier: SearchHeaderTableViewCell.identifier) as? SearchHeaderTableViewCell else {return UITableViewCell()}
        switch section{
        case 0:
            header.titleLabel.text = "Artists"
        default:
            header.titleLabel.text = "Tracks"
        }
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    
}

extension SearchViewController : UISearchBarDelegate {
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        self.viewModel.searchText.send(searchBar.text ?? nil)
        self.viewModel.Search()
        self.view.endEditing(true)
        return true
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.viewModel.searchText.send(nil)
        self.viewModel.Search()
        self.view.endEditing(true)
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.viewModel.searchText.send(searchBar.text ?? nil)
        self.viewModel.Search()
        self.view.endEditing(true)
    }
}
