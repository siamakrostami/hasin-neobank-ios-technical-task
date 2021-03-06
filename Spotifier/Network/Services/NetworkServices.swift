//
//  NetworkServices.swift
//  Spotifier
//
//  Created by Siamak Rostami on 7/11/22.
//

import Foundation

struct NetworkServices {
    
    lazy var authenticationService : SpotifyAuthRepository = {
        return SpotifyAuthRepository()
    }()
    
    lazy var searchService : SearchRepository = {
       return SearchRepository()
    }()
    
    lazy var recommendedService : ReleasesRepository = {
       return ReleasesRepository()
    }()
    
    
}
