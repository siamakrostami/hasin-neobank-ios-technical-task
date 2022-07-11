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
    
    init(limit : Int , delay : TimeInterval){
        self.limit = limit
        self.delay = delay
        super.init()
    }
    
    override func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var adaptedRequest = urlRequest
        guard let token = UserInfoModel.shared.getUserToken() else {
            completion(.success(adaptedRequest))
            return
        }
        adaptedRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        completion(.success(adaptedRequest))
        
    }
    override func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        if let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401 {
        }
    }
}
