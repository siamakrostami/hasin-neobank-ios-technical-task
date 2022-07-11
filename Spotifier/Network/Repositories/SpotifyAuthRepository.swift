//
//  SpotifyAuthRepository.swift
//  Spotifier
//
//  Created by Siamak Rostami on 7/11/22.
//

import Foundation
import Alamofire

typealias TokenCompletion = ((Result<TokenModel?,ClientError>) -> Void)

protocol AuthenticationProtocols {
    func getToken(code : String , completion : @escaping TokenCompletion)
    func getRefreshToken(refreshToken : String , completion : @escaping TokenCompletion)
}

struct SpotifyAuthRepository{
    
    private let client : APIClient
    init(client : APIClient = APIClient()){
        self.client = client
    }
}

extension SpotifyAuthRepository : AuthenticationProtocols{
    func getToken(code: String, completion: @escaping TokenCompletion) {
        self.client.request(AuthRouter.getToken(code: code), result: completion)
    }
    
    func getRefreshToken(refreshToken: String, completion: @escaping TokenCompletion) {
        self.client.request(AuthRouter.getRefreshToken(refreshToken: refreshToken), result: completion)
    }
    
}

extension SpotifyAuthRepository{
    
    enum AuthRouter : NetworkRouter{
        case getToken(code : String)
        case getRefreshToken(refreshToken : String)
        
        var method: RequestMethod?{
            switch self {
            case .getToken(_):
                return .post
            case .getRefreshToken(_):
                return .post
            }
        }
        
        var encoding: ParameterEncoding?{
            return URLEncoding.init(destination: .httpBody, arrayEncoding: .noBrackets, boolEncoding: .literal)
        }
        
        var baseURLString: String{
            return Constants.tokenApiURL
        }
        var path: String{
            return Constants.tokenApiPath
        }
        var headers: [String : String]?{
            return ["Authorization" : "Basic \(Constants.credential.toBase64()) " , "Content-Type":"application/x-www-form-urlencoded"]
        }
        var params: [String : Any]?{
            switch self {
            case .getToken(let code):
                return self.setTokenParams(code: code)
            case .getRefreshToken(let refreshToken):
                return self.setRefreshTokenParams(refreshToken: refreshToken)
            }
        }
        var isURLEncoded: Bool{
            return true
        }
        
        private func setTokenParams(code : String) -> [String:Any]? {
            var dictionary = Dictionary<String,Any>()
            dictionary.updateValue(code, forKey: "code")
            dictionary.updateValue("authorization_code", forKey: "grant_type")
            dictionary.updateValue(Constants.redirectURI, forKey: "redirect_uri")
            return dictionary
        }
        
        private func setRefreshTokenParams(refreshToken : String) -> [String:Any]?{
            var dictionary = Dictionary<String,Any>()
            dictionary.updateValue(refreshToken, forKey: "refresh_token")
            dictionary.updateValue("refresh_token", forKey: "grant_type")
            return dictionary
        }
        
    }
}
