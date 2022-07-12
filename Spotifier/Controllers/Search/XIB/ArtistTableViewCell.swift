//
//  ArtistTableViewCell.swift
//  Spotifier
//
//  Created by Siamak Rostami on 7/12/22.
//

import UIKit
import SDWebImage

class ArtistTableViewCell: UITableViewCell {
    
    @IBOutlet weak var artistImageView: UIImageView!
    @IBOutlet weak var artistNameLabel: UILabel!
    static let identifier = "ArtistTableViewCell"
    
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
        self.artistImageView.sd_cancelCurrentImageLoad()
        self.artistImageView.image = nil
    }
    
    func configureArtistCell(model : ArtistsItem){
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
        DispatchQueue.main.async {
            self.artistNameLabel.text = model.name
        }
        
    }
    
}
