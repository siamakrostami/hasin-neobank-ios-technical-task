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
    
    
}
