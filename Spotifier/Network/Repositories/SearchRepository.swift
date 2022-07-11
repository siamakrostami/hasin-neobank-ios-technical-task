//
//  SearchRepository.swift
//  Spotifier
//
//  Created by Siamak Rostami on 7/11/22.
//

import Foundation
import Alamofire

typealias SearchCompletion = ((Result<Search?,ClientError>) -> Void)

protocol SearchRepositoryProtocols{
    func searchItem(searchQuery : String ,offset : Int, completion:@escaping SearchCompletion)
}

struct SearchRepository{
    private let client : APIClient
    init(client : APIClient = APIClient()){
        self.client = client
    }
}

extension SearchRepository : SearchRepositoryProtocols{
    func searchItem(searchQuery: String, offset : Int,completion: @escaping SearchCompletion) {
        self.client.request(SearchRouter.searchItem(query: searchQuery, offset: offset), result: completion)
    }
    
    
}

extension SearchRepository{
    
    enum SearchRouter : NetworkRouter{
        
        case searchItem(query : String , offset : Int)
        
        var method: RequestMethod?{
            return .get
        }
        
        var encoding: ParameterEncoding?{
            return JSONEncoding.default
        }
        
        var baseURLString: String{
            return Constants.baseApiURL
        }
        var path: String{
            switch self {
            case .searchItem(let query, let offset):
                return Constants.searchPatch.replacingOccurrences(of: "{{search}}", with: query).replacingOccurrences(of: "{{offset}}", with: "\(offset)")
            }
        }
        var headers: [String : String]?{
            return ["Authorization" : UserInfoModel.shared.getUserToken() ?? "" , "Content-Type": "application/json"]
        }
        var params: [String : Any]?{
            return [:]
        }
        
        
    }
    
}
