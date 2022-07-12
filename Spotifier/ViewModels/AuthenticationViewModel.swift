//
//  AuthenticationViewModel.swift
//  Spotifier
//
//  Created by Siamak Rostami on 7/11/22.
//

import Foundation
import Combine
import AVKit

protocol AuthViewModelProtocols{
    func getToken(code : String)
    func getRefreshToken(refreshToken:String)
}

class AuthenticationViewModel{
    
    var networkServices : NetworkServices
    var isLoginSuccess = CurrentValueSubject<Bool?,Never>(nil)
    var disposeBag : Set<AnyCancellable> = []
    var error = CurrentValueSubject<ClientError?,Never>(nil)
    var player : AVPlayer?
    
    init(services : NetworkServices = NetworkServices()){
        self.networkServices = services
    }

}

extension AuthenticationViewModel : AuthViewModelProtocols{
    
    @objc func playSampleSong(){
        self.initAudioNotification()
        try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
        try? AVAudioSession.sharedInstance().setActive(true)
        guard let url = Bundle.main.url(forResource: "sorrow", withExtension: "mp3") else {return}
        self.player = AVPlayer(url: url)
        self.player?.play()
    }
    
    @objc func resetAudio(){
        self.player?.seek(to: .zero)
        self.player?.play()
    }
    
    private func initAudioNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(resetAudio), name: .AVPlayerItemDidPlayToEndTime, object: nil)
    }
    private func deinitNotification(){
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: nil)
        
    }
    @objc func deinitPlayer(){
        try? AVAudioSession.sharedInstance().setCategory(.soloAmbient, mode: .default)
        try? AVAudioSession.sharedInstance().setActive(true)
        if self.player != nil{
            self.player?.pause()
            self.player?.replaceCurrentItem(with: nil)
            self.player = nil
        }
        self.deinitNotification()
    }
    
    
    
    
    
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
