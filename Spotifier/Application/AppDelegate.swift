//
//  AppDelegate.swift
//  Spotifier
//
//  Created by Siamak Rostami on 7/11/22.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.setRootController()
        // Override point for customization after application launch.
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        print(url)
        return true
    }

}

extension AppDelegate {
    
    func setRootController(){
        if let _ = UserInfoModel.shared.getUserToken(){
            setLoginController()
        }else{
            setLoginController()
        }
    }
    
    func setLoginController(){
        guard let rootVc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AuthenticationViewController") as? AuthenticationViewController else {return}
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .white
        let rootNavigation = UINavigationController(rootViewController: rootVc)
        rootNavigation.isNavigationBarHidden = true
        window?.rootViewController = rootNavigation
        window?.makeKeyAndVisible()
    }
    
    
}

