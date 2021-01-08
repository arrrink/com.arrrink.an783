//
//  AppDelegate.swift
//  com.arrrink.StreetArtMarketplace
//
//  Created by Арина Нефёдова on 19.08.2020.
//  Copyright © 2020 Арина Нефёдова. All rights reserved.
//

import UIKit
import Firebase
import GooglePlaces
import GoogleMaps

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
       
       // UINavigationController.init().interactivePopGestureRecognizer?.delegate = nil
      //  UINavigationController.init().interactivePopGestureRecognizer?.isEnabled = true
      //  let appearance = UINavigationBarAppearance()
        
       // appearance.configureWithOpaqueBackground()
       
    //    UINavigationBar.appearance().showsLargeContentViewer = false
       // UINavigationBar.appearance().standardAppearance = appearance
      //  UINavigationBar.appearance().compactAppearance = appearance
//        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Ubuntu", size: 27), NSAttributedString.Key.foregroundColor:UIColor.white]
//        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "Ubuntu-Light", size: 15), NSAttributedString.Key.foregroundColor:UIColor.white], for: .highlighted)
       // UINavigationBar.appearance().backgroundColor = .clear
     //   UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().tintColor = .red
        
//        UITableView.appearance().backgroundColor = .white
//        UITableView.appearance().backgroundView = .none
//        UITableView.appearance().separatorStyle = .none
//        UITableView.appearance().separatorColor = .clear
//
//        UITableView.appearance().separatorEffect = .none
//
//        UITableViewCell.appearance().contentView.backgroundColor = .white
//           UITableViewCell.appearance().backgroundColor = .white
//           UITableView.appearance().tableFooterView = UIView()
       // UINavigationBarAppearance.init(barAppearance: UIBarAppearance())
        FirebaseApp.configure()
        GMSServices.provideAPIKey("AIzaSyAsGfs4rovz0-6EFUerfwiSA6OMTs2Ox-M")
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

