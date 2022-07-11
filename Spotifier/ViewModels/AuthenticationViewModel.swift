//
//  AuthenticationViewModel.swift
//  Spotifier
//
//  Created by Siamak Rostami on 7/11/22.
//

import Foundation
import Combine

protocol AuthViewModelProtocols{
    func getToken(code : String)
    func getRefreshToken(refreshToken:String)
}

class AuthenticationViewModel{
    
    var networkServices : NetworkServices
    var isLoginSuccess = CurrentValueSubject<Bool?,Never>(nil)
    var disposeBag : Set<AnyCancellable> = []
    var error = CurrentValueSubject<ClientError?,Never>(nil)
    
    init(services : NetworkServices = NetworkServices()){
        self.networkServices = services
    }

}

extension AuthenticationViewModel : AuthViewModelProtocols{
    func getToken(code: String) {
        self.networkServices.authenticationService.getToken(code: code) { [weak self] response in
            guard let `self` = self else {return}
            switch response{
            case .success(let token):
                UserInfoModel.shared.setUserToken(token: token?.accessToken)
                UserInfoModel.shared.setRefreshToken(refresh: token?.refreshToken)
                self.isLoginSuccess.send(true)
            case .failure(let error):
                self.isLoginSuccess.send(false)
                self.error.send(error)
            }
        }
    }
    
    func getRefreshToken(refreshToken: String) {
        guard let refreshToken = UserInfoModel.shared.getRefreshToken() else {return}
        self.networkServices.authenticationService.getRefreshToken(refreshToken: refreshToken) { [weak self] response in
            guard let `self` = self else {return}
            switch response{
            case .success(let token):
                UserInfoModel.shared.setUserToken(token: token?.accessToken)
                UserInfoModel.shared.setRefreshToken(refresh: token?.refreshToken)
            case .failure(let error):
                self.error.send(error)
            }
        }
    }
    
    
}
