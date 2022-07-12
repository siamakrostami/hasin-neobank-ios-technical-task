//
//  UIViewController+Extensions.swift
//  Spotifier
//
//  Created by Siamak Rostami on 7/11/22.
//

import Foundation
import UIKit

extension UIViewController{
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    class var storyboardID : String {
        return "\(self)"
    }
    
    static func instantiate(fromAppStoryboard : AppStoryboard) -> Self {
        return fromAppStoryboard.viewController(viewControllerClass: self)
    }
    
    enum AppStoryboard : String {
        case Main,AuthWebView,Search,Artist,Track
        
        var instance : UIStoryboard {
            return UIStoryboard(name: self.rawValue, bundle: Bundle.main)
        }
        
        func viewController<T : UIViewController>(viewControllerClass : T.Type) -> T {
            let storyboardID = (viewControllerClass as UIViewController.Type).storyboardID
            return instance.instantiateViewController(withIdentifier: storyboardID) as! T
        }
        
        func initialViewController() -> UIViewController? {
            return instance.instantiateInitialViewController()
        }
    }
    
}
