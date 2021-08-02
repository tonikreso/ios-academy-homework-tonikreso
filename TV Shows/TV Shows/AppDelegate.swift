//
//  AppDelegate.swift
//  TV Shows
//
//  Created by Infinum on 08.07.2021..
//

import UIKit
import KeychainAccess

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let keychain = Keychain(service: "userInfo")
            
        let navigationController = UINavigationController()
        let authInfoAccessToken: String? = keychain["accessToken"]
        
        if authInfoAccessToken != nil {
            let authInfo = AuthInfo(
                accessToken: keychain["accessToken"]!,
                client: keychain["client"]!,
                tokenType: keychain["tokenType"]!,
                expiry: keychain["expiry"]!,
                uid: keychain["uid"]!
            )
            let storyboard = UIStoryboard.init(name: "Home", bundle: nil)
            let homeVC = storyboard.instantiateViewController(withIdentifier: "HomeVC") as! HomeViewController
            homeVC.addAuthInfo(authInfo: authInfo)
            navigationController.viewControllers = [homeVC]
        } else {
            let storyboard = UIStoryboard.init(name: "Login", bundle: nil)
            let loginViewController = storyboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginViewController
            navigationController.viewControllers = [loginViewController]
        }
        
        navigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController.navigationBar.shadowImage = UIImage()
        window?.rootViewController = navigationController
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    


}

