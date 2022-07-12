//
//  SearchViewModel.swift
//  Spotifier
//
//  Created by Siamak Rostami on 7/11/22.
//

import Foundation
import Combine

protocol SearchViewModelProtocols{
    func searchItem(query : String?)
    func getRecommended()
}

class SearchViewModel{
    var networkServices : NetworkServices
    var limit : Int = 20
    var offset : Int = 0
    var recommendedOffset : Int = 0
    var recommendedLimit : Int = 20
    var error = CurrentValueSubject<ClientError?,Never>(nil)
    var isLoading = CurrentValueSubject<Bool,Never>(false)
    var shouldUpdateCollection = CurrentValueSubject<Bool?,Never>(nil)
    var searchModel : Search?
    var recommendedModel : Search?
    var searchAlbum = Albums()
    var searchTrack = Tracks()
    var searchArtist = Artist()
    var recommendedAlbum = Albums()
    
    

    init(services : NetworkServices = NetworkServices()){
        self.networkServices = services
    }
  
}

extension SearchViewModel : SearchViewModelProtocols{
    
    func getRecommended() {
        isLoading.send(true)
        self.networkServices.recommendedService.getRecommended(limit: recommendedLimit, offset: recommendedOffset) { [weak self] response in
            guard let `self` = self else {
                self?.isLoading.send(false)
                return
            }
            switch response{
            case .success(let model):
                self.isLoading.send(false)
                self.recommendedModel = model
            case .failure(let error):
                self.isLoading.send(false)
                self.error.send(error)
            }
        }
    }
    
    func searchItem(query: String?) {
        isLoading.send(true)
        self.networkServices.searchService.searchItem(searchQuery: query ?? "", offset: self.offset , limit: self.limit) { [weak self] response in
            guard let `self` = self else {
                self?.isLoading.send(false)
                return
            }
            switch response{
            case .success(let model):
                self.isLoading.send(false)
                self.searchModel = model
                
            case .failure(let error):
                self.isLoading.send(false)
                self.error.send(error)
                
            }
        }
    }
    
    
    
}
