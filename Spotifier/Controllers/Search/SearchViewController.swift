//
//  SearchViewController.swift
//  Spotifier
//
//  Created by Siamak Rostami on 7/11/22.
//

import UIKit

class SearchViewController: UIViewController {
    
    private lazy var viewModel : SearchViewModel = {
       return SearchViewModel()
    }()
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchTableView: UITableView!{
        didSet{
            searchTableView.delegate = self
            searchTableView.dataSource = self
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        viewModel.getRecommended()
        // Do any additional setup after loading the view.
    }
    


}

extension SearchViewController {
    
    static func build() -> SearchViewController{
        let controller = AppStoryboard.Search.viewController(viewControllerClass: SearchViewController.self)
        return controller
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
