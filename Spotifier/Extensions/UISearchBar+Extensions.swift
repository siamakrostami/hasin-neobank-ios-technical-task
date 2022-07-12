//
//  UISearchBar+Extensions.swift
//  Spotifier
//
//  Created by Siamak Rostami on 7/13/22.
//

import Foundation
import UIKit

extension UISearchBar {
    public var textField: UITextField {
        if #available(iOS 13.0, *) {
            return searchTextField
        }
        
        guard let firstSubview = subviews.first else {
            fatalError("Could not find text field")
        }
        
        for view in firstSubview.subviews {
            if let textView = view as? UITextField {
                return textView
            }
        }
        
        fatalError("Could not find text field")
    }
}
