//
//  SearchHeaderTableViewCell.swift
//  Spotifier
//
//  Created by Siamak Rostami on 7/12/22.
//

import UIKit

class SearchHeaderTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    static let identifier = "SearchHeaderTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
