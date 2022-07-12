//
//  ArtistViewController.swift
//  Spotifier
//
//  Created by Siamak Rostami on 7/13/22.
//

import UIKit
import SDWebImage

class ArtistViewController: UIViewController {
    
    
    @IBOutlet weak var artistImageView: UIImageView!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var popularityLabel: UILabel!
    private var model : ArtistsItem!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.initializeData()
    }
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    

}

extension ArtistViewController {
    
    static func build(model : ArtistsItem) -> ArtistViewController{
        let controller = AppStoryboard.Artist.viewController(viewControllerClass: ArtistViewController.self)
        controller.model = model
        return controller
    }
    
    private func initializeData(){
        self.setImage()
        DispatchQueue.main.async {
            self.artistNameLabel.text = self.model.name
            self.followersLabel.text = "\(self.model.followers?.total ?? 0)"
            self.popularityLabel.text = "\(self.model.popularity ?? 0)%"
        }
        
    }
    
    private func setImage(){
        let imageUrl = model.images?.first?.url
        if let cached = SDImageCache.shared.imageFromDiskCache(forKey: imageUrl){
            DispatchQueue.main.async {
                self.artistImageView.image = cached
            }
        }else{
            //Load Image from remote URL and cache it on disk
            DispatchQueue.main.async {
                let url = URL(string: imageUrl ?? "")
                self.artistImageView.sd_setImage(with: url)
            }
        }
    }
    

}
