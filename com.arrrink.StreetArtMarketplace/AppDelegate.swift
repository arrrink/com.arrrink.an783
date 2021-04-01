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
import FirebaseAuth
import FirebaseInstallations
import FirebaseMessaging
import UserNotifications


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {

var gcmMessageIDKey = "gcm.message.id"
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        
        UINavigationBar.appearance().tintColor = .red
        FirebaseApp.configure()
        
//
//        if #available(iOS 10.0, *) {
//                    // For iOS 10 display notification (sent via APNS)
//                    UNUserNotificationCenter.current().delegate = self
//                    let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
//                    UNUserNotificationCenter.current().requestAuthorization(
//                        options: authOptions,
//                        completionHandler: {_, _ in })
//                } else {
//                    let settings: UIUserNotificationSettings =
//                        UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
//                    application.registerUserNotificationSettings(settings)
//                }

              //  application.registerForRemoteNotifications()

               // Messaging.messaging().delegate = self
       
        
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
   
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
      let firebaseAuth = Auth.auth()
      firebaseAuth.setAPNSToken(deviceToken, type: AuthAPNSTokenType.prod)

  }


    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
      // If you are receiving a notification message while your app is in the background,
      // this callback will not be fired till the user taps on the notification launching the application.
      // TODO: Handle data of notification

      // With swizzling disabled you must let Messaging know about the message, for Analytics
      // Messaging.messaging().appDidReceiveMessage(userInfo)

      // Print message ID.
//      if let messageID = userInfo[gcmMessageIDKey] {
//        print("Message ID: \(messageID)")
//      }
//
//      // Print full message.
//      print(userInfo)
//
//      completionHandler(UIBackgroundFetchResult.newData)
    }
}

