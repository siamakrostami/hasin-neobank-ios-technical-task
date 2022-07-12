//
//  UITableView+Extensions.swift
//  Spotifier
//
//  Created by Siamak Rostami on 7/12/22.
//

import Foundation
import UIKit

extension UITableView{
    func setEmptyState(message : String? = nil , image : String){
        //main view
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        view.backgroundColor = .clear
        //image view
        let image = UIImage(systemName: image)?.withRenderingMode(.alwaysTemplate)
        let imageView = UIImageView(image: image)
        imageView.tintColor = .white
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        //label view
        let messageLabel = UILabel()
        messageLabel.text = message ?? "Search for tracks or artists"
        messageLabel.textColor = .white
        messageLabel.textAlignment = .center
        messageLabel.font = .systemFont(ofSize: 17, weight: .medium)
        messageLabel.sizeToFit()
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(view)
        view.addSubview(imageView)
        view.addSubview(messageLabel)
        addConstraint(NSLayoutConstraint(item: imageView, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: imageView, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: imageView, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 0.2, constant: 0))
        addConstraint(NSLayoutConstraint(item: imageView, attribute: .height, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 0.2, constant: 0))
        addConstraint(NSLayoutConstraint(item: messageLabel, attribute: .centerX, relatedBy: .equal, toItem: imageView, attribute: .centerX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: messageLabel, attribute: .top, relatedBy: .equal, toItem: imageView, attribute: .bottom, multiplier: 1, constant: 16))
        self.backgroundView = view
        self.separatorStyle = .none
        
    }
    
    func restoreNotificationsState(){
        self.backgroundView = nil
        self.separatorStyle = .none
    }
}
