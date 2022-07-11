//
//  AuthenticationViewController.swift
//  Spotifier
//
//  Created by Siamak Rostami on 7/11/22.
//

import UIKit

class AuthenticationViewController: BaseViewController {
    
    private lazy var authWebView : AuthWebViewViewController = {
        return AuthWebViewViewController.buildController()
    }()
    
    private lazy var viewModel : AuthenticationViewModel = {
       return AuthenticationViewModel()
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        self.viewModel.playSampleSong()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.viewModel.deinitPlayer()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bindToken()
        self.bindError()
        self.bindIsLoginSuccess()
        title = "Spotifier"
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func login(_ sender: Any) {
        self.navigateToLogin()
    }
    
}

extension AuthenticationViewController {
    private func navigateToLogin(){
        self.navigationController?.pushViewController(self.authWebView, animated: true)
    }
    
    private func bindToken(){
        authWebView.token
            .subscribe(on: RunLoop.main)
            .sink { [weak self] token in
                guard let `self` = self else {return}
                guard let token = token else {return}
                self.viewModel.getToken(code: token)
            }
            .store(in: &authWebView.disposeBag)
    }
    
    private func bindError(){
        self.viewModel.error
            .subscribe(on: RunLoop.main)
            .sink { [weak self] error in
                guard let `self` = self else {return}
                guard let error = error else {return}
                self.showError(message: error.localizedDescription)
            }
            .store(in: &viewModel.disposeBag)
    }
    
    private func bindIsLoginSuccess(){
        self.viewModel.isLoginSuccess
            .subscribe(on: RunLoop.main)
            .sink { [weak self] isSuccess in
                guard let `self` = self else {return}
                guard let isSuccess = isSuccess else {return}
                if isSuccess{
                    self.navigateToDiscovery()
                }
            }
            .store(in: &viewModel.disposeBag)
    }
    
    private func navigateToDiscovery(){
        
    }
    
    
}
