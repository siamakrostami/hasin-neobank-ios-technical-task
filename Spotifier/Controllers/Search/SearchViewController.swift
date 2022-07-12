//
//  SearchViewController.swift
//  Spotifier
//
//  Created by Siamak Rostami on 7/11/22.
//

import UIKit

class SearchViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()

        // Do any additional setup after loading the view.
    }
    


}

extension SearchViewController {
    
    static func build() -> SearchViewController{
        let controller = AppStoryboard.Search.viewController(viewControllerClass: SearchViewController.self)
        return controller
    }
}
