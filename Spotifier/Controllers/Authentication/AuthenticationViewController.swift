//
//  AuthenticationViewController.swift
//  Spotifier
//
//  Created by Siamak Rostami on 7/11/22.
//

import UIKit

class AuthenticationViewController: UIViewController {
    
    private lazy var authWebView : AuthWebViewViewController = {
        return AuthWebViewViewController.buildController()
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bindToken()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func login(_ sender: Any) {
        self.navigateToLogin()
    }
    
}

extension AuthenticationViewController {
    private func navigateToLogin(){
        self.navigationController?.pushViewController(authWebView, animated: true)
    }
    
    private func bindToken(){
        authWebView.token
            .subscribe(on: RunLoop.main)
            .sink { [weak self] token in
                guard let `self` = self else {return}
            }
            .store(in: &authWebView.disposeBag)
    }
}
