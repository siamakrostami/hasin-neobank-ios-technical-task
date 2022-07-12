//
//  TrackPlayerHelper.swift
//  Spotifier
//
//  Created by Siamak Rostami on 7/13/22.
//

import Foundation
import AVKit
import Combine

class TrackPlayerHelper {
    let playIcon = "play.fill"
    let pauseIcon = "pause.fill"
    var isPlaying = CurrentValueSubject<Bool,Never>(false)
    var player : AVPlayer?
    var urlString : String
    var disposeBag : Set<AnyCancellable> = []
    
    init(url : String){
        self.urlString = url
        self.initializePlayer()
        self.initNotification()
    }
 
}

extension TrackPlayerHelper{
    
    func initNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinished), name: .AVPlayerItemDidPlayToEndTime, object: nil)
    }
    
    @objc func playerDidFinished(){
        if player != nil{
            self.player?.seek(to: .zero)
            self.player?.pause()
            self.isPlaying.send(false)
        }
    }
    
    func deinitNotification(){
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: nil)
    }
    
    func deinitPlayer(){
        if player != nil{
            self.player?.seek(to: .zero)
            self.player?.pause()
            self.isPlaying.send(false)
            self.player = nil
            self.deinitNotification()
        }
    }
    
    func play(){
        self.isPlaying.send(true)
        self.player?.play()
    }
    
    func pause(){
        self.isPlaying.send(false)
        self.player?.pause()
    }
    
    func initializePlayer(){
        guard let url = URL(string: self.urlString) else {return}
        self.player = AVPlayer(url: url)
    }
    
    
    
    
}
