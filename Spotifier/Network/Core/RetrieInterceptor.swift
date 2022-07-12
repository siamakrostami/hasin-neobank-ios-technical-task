//
//  RetrieInterceptor.swift
//  Spotifier
//
//  Created by Siamak Rostami on 5/25/22.
//

import Foundation
import Alamofire

final class RetrierInterceptor : Interceptor {
    private var limit : Int
    private var delay : TimeInterval
    private var network : NetworkServices
    
    init(limit : Int , delay : TimeInterval){
        self.limit = limit
        self.delay = delay
        self.network = NetworkServices()
        super.init()
    }
    
    override func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        debugPrint("adapted")
        var adaptedRequest = urlRequest
        guard let token = UserInfoModel.shared.getUserToken() else {
            completion(.success(adaptedRequest))
            return
        }
        adaptedRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        completion(.success(adaptedRequest))
        
    }
    override func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        debugPrint("retry")
        if request.retryCount < limit {
            completion(.doNotRetry)
        }
        if let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401 {
            guard let refresh = UserInfoModel.shared.getRefreshToken() else {return}
            self.network.authenticationService.getRefreshToken(refreshToken: refresh) { response in
                switch response{
                case .success(let token):
                    UserInfoModel.shared.setUserToken(token: token?.accessToken)
                    UserInfoModel.shared.setRefreshToken(refresh: token?.refreshToken)
                    completion(.retry)
                case .failure(let error):
                    if error.rawValue == 400{
                        completion(.doNotRetry)
                        UserInfoModel.shared.logoutUser()
                        let app = UIApplication.shared.delegate as? AppDelegate
                        app?.setRootController()
                    }else{
                        completion(.retry)
                    }
                    
                }
            }
        }
        completion(.retry)
    }
}
