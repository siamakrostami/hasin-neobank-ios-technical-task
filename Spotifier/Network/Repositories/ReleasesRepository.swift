//
//  ReleasesRepository.swift
//  Spotifier
//
//  Created by Siamak Rostami on 7/12/22.
//

import Foundation
import Alamofire

typealias ReleaseCompletion = ((Result<Search?,ClientError>) -> Void)

protocol ReleaseProtocols{
    func getRecommended(limit : Int , offset : Int , completion:@escaping ReleaseCompletion)
}

struct ReleasesRepository {
    private let client : APIClient
    init(client : APIClient = APIClient()){
        self.client = client
    }
}

extension ReleasesRepository : ReleaseProtocols{
    func getRecommended(limit: Int, offset: Int, completion: @escaping ReleaseCompletion) {
        client.request(ReleaseRouter.getRecommended(limit: limit, offset: offset), result: completion)
    }
    
    
}

extension ReleasesRepository{
    
    enum ReleaseRouter : NetworkRouter{
        case getRecommended(limit : Int , offset : Int)
        
        var baseURLString: String{
            return Constants.baseApiURL
        }
        var path: String{
            switch self {
            case .getRecommended(let limit, let offset):
                return Constants.newReleasesPath.replacingOccurrences(of: "{{offset}}", with: "\(offset)").replacingOccurrences(of: "{{limit}}", with: "\(limit)")
            }
        }
        var method: RequestMethod?{
            return .get
        }
        var encoding: ParameterEncoding?{
            return JSONEncoding.default
        }
        var headers: [String : String]?{
            return ["Authorization" : UserInfoModel.shared.getUserToken() ?? "" , "Content-Type": "application/json"]
        }
        var params: [String : Any]?{
            return [:]
        }

    }
  
}
