//
//  SearchViewController.swift
//  Spotifier
//
//  Created by Siamak Rostami on 7/11/22.
//

import UIKit

class SearchViewController: BaseViewController {
    
    private lazy var viewModel : SearchViewModel = {
       return SearchViewModel()
    }()
    
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
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        self.bindError()
        self.bindSearchText()
        self.bindIsLoading()
        self.bindShouldUpdate()
        // Do any additional setup after loading the view.
    }
    


}

extension SearchViewController {
    
    static func build() -> SearchViewController{
        let controller = AppStoryboard.Search.viewController(viewControllerClass: SearchViewController.self)
        return controller
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
        tableView.setEmptyState(message: nil, image: "magnifyingglass")
        return 0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    
}

extension SearchViewController : UISearchBarDelegate {
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        self.viewModel.searchText.send(searchBar.text)
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
        self.viewModel.searchText.send(searchBar.text)
        self.viewModel.Search()
        self.view.endEditing(true)
    }
}
