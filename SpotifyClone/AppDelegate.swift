//
//  AppDelegate.swift
//  SpotifyClone
//
//  Created by Ahmad on 13/07/2021.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let window = UIWindow(frame: UIScreen.main.bounds)
        if AuthenticationManager.shared.isUserSignedIn {
            let searchVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
            let navigationVC = UINavigationController(rootViewController: searchVC)
            navigationVC.viewControllers.first?.navigationItem.largeTitleDisplayMode = .automatic
            window.rootViewController = navigationVC
        } else {
            let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            let navigationVC = UINavigationController(rootViewController: loginVC)
            window.rootViewController = navigationVC
        }
        window.makeKeyAndVisible()
        self.window = window
        return true
    }

}

