//
//  TrackViewController.swift
//  Spotifier
//
//  Created by Siamak Rostami on 7/13/22.
//

import UIKit
import SDWebImage

class TrackViewController: UIViewController {
    
    @IBOutlet weak var trackImageView: UIImageView!
    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var albumNameLabel: UILabel!
    @IBOutlet weak var popularityLabel: UILabel!
    @IBOutlet weak var playOutlet: UIButton!
    
    private var model : TracksItem!
    private var trackHelper : TrackPlayerHelper!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.initializeData()
        self.initTrackHelper()
        self.bindIsPlaying()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.trackHelper.deinitPlayer()
    }
    deinit{
        self.trackHelper.deinitPlayer()
    }
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func playOrPause(_ sender: Any) {
        if self.trackHelper.isPlaying.value{
            self.trackHelper.pause()
        }else{
            self.trackHelper.play()
        }
    }
    
}

extension TrackViewController{
    
    private func initTrackHelper(){
        self.trackHelper = TrackPlayerHelper(url: model.previewURL ?? "")
    }
    
    private func bindIsPlaying(){
        self.trackHelper.isPlaying
            .subscribe(on: RunLoop.main)
            .sink { [weak self] isPlaying in
                guard let `self` = self else {return}
                if isPlaying{
                    self.playOutlet.setImage(UIImage(systemName: self.trackHelper.pauseIcon), for: .normal)
                }else{
                    self.playOutlet.setImage(UIImage(systemName: self.trackHelper.playIcon), for: .normal)
                }
            }
            .store(in: &self.trackHelper.disposeBag)
    }
    
    static func build(model : TracksItem) -> TrackViewController {
        let controller = AppStoryboard.Track.viewController(viewControllerClass: TrackViewController.self)
        controller.model = model
        return controller
    }
    
    private func initializeData(){
        self.setImage()
        DispatchQueue.main.async {
            self.trackNameLabel.text = self.model.name
            self.albumNameLabel.text = self.model.album?.name
            self.popularityLabel.text = "\(self.model.popularity ?? 0)%"
        }
        
    }
    
    private func setImage(){
        let imageUrl = model.album?.images?.first?.url
        if let cached = SDImageCache.shared.imageFromDiskCache(forKey: imageUrl){
            DispatchQueue.main.async {
                self.trackImageView.image = cached
            }
        }else{
            //Load Image from remote URL and cache it on disk
            DispatchQueue.main.async {
                let url = URL(string: imageUrl ?? "")
                self.trackImageView.sd_setImage(with: url)
            }
        }
    }
    
    
    
    
    
}
