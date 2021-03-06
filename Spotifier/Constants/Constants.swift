//
//  Constants.swift
//  Spotifier
//
//  Created by Siamak Rostami on 7/11/22.
//

import Foundation
import UIKit

struct Constants{
    
    static let baseApiURL = "https://api.spotify.com/v1/"
    static let newReleasesPath = "browse/new-releases?limit={{limit}}&offset={{offset}}"
    static let searchPatch = "search?q={{search}}&type=artist,track&include_external=audio&limit={{limit}}&offset={{offset}}"
    static let clientId = "dfcea584767d400f9c1f254398d1946b"
    static let clientSecret = "84432bf867cb4cf5aac283e3e9f9007d"
    static let tokenApiURL = "https://accounts.spotify.com/"
    static let tokenApiPath = "api/token"
    static let scopes = "user-read-private"
    static let redirectURI = "http://localhost:8888/callback"
    static let authenticationBaseURL = "https://accounts.spotify.com/authorize"
    static let authenticationBody = "?response_type=code&client_id=\(Constants.clientId)&scope=\(Constants.scopes)&redirect_uri=\(redirectURI)&show_dialog=TRUE".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    static var credential : String {
        return clientId + ":" + clientSecret
    }
    static let estimatedRow : CGFloat = 100
    static let headerHeight : CGFloat = 40
    static let artistTitle = "Artists"
    static let tracksTitle = "Tracks"

}
