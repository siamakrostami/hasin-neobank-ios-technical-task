//
//  TrackTableViewCell.swift
//  Spotifier
//
//  Created by Siamak Rostami on 7/12/22.
//

import UIKit
import SDWebImage

class TrackTableViewCell: UITableViewCell {
    
    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var trackImageView: UIImageView!
    static let identifier = "TrackTableViewCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.trackImageView.sd_cancelCurrentImageLoad()
        self.trackImageView.image = nil
    }
    
    func configureTrackCell(model : TracksItem){
        
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
        DispatchQueue.main.async {
            self.trackNameLabel.text = model.name
            guard let artist = model.artists else {return}
            self.artistNameLabel.text = artist.first?.name
        }
        
    }
    
}
