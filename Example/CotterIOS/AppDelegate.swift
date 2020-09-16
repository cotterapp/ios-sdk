//
//  AppDelegate.swift
//  CotterIOS
//
//  Created by albertputrapurnama on 02/01/2020.
//  Copyright (c) 2020 albertputrapurnama. All rights reserved.
//

import UIKit
import Cotter
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        // Override point for customization after application launch.
        
        // set default credentials
        var apiKeyID = "b6e64a6d-ecc9-4582-b8bb-cdd1715b063b"
        var apiSecretKey = "KLKqAQ6QXEScmQbYvtJm"
        
        if let key = Environment.shared.COTTER_API_KEY_ID {
            apiKeyID = key
        }
        
        if let key = Environment.shared.COTTER_API_SECRET_KEY { 
            apiSecretKey = key
        }
        
        // check if any user is already logged in by checking the access token
        let userID = Cotter.getLoggedInUserID()
        if userID != nil {
            let eVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EntryViewController") as! EntryViewController
            // for test redirect to PIN
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewController") as! ViewController
            let nav = CustomNavigationViewController(rootViewController: eVC)
            nav.pushViewController(vc, animated: true)
            self.window?.rootViewController = nav
            self.window?.makeKeyAndVisible()
        }
        
        CotterWrapper.cotter = Cotter(
            apiSecretKey: apiSecretKey,
            apiKeyID: apiKeyID,
//            cotterURL: "http://192.168.86.28:1234/api/v0",
            cotterURL: "https://www.cotter.app/api/v0",
            userID: "ff570626-56e7-4260-a82b-5951038e29ea",
            // configuration is an optional argument, remove this below and Cotter app will still function properly
            configuration: [:]
        )
        
        // if you want to start PINViewControler on startup, use getPINViewController
//        let vc = CotterWrapper.cotter!.getTransactionPINViewController(hideClose: true, cb: Callback.shared.authCb)
//        let nav = UINavigationController(rootViewController: vc)
//        self.window?.rootViewController = nav
//        self.window?.makeKeyAndVisible()
        
        // the following configuration is optional, only use this if you want to use your own fonts
//        let customFont = FontObject()
//        customFont.title = UIFont.systemFont(ofSize: 9.0)
//        customFont.subtitle = UIFont.boldSystemFont(ofSize: 35.0)
//        customFont.keypad = UIFont.boldSystemFont(ofSize: 10.0)
        
        // let lang = Indonesian()
        // lang.setText(for: PINViewControllerKey.navTitle, to: "Hello world!")
        
        // let img = ImageObject()
        // img.setImage(for: VCImageKey.pinSuccessImg, to: "telegram")
        
        // custom coloring
        let color = ColorSchemeObject(primary: CotterColor.purple, accent: CotterColor.orange)
        
        Cotter.configureWithLaunchOptions(
            launchOptions: launchOptions,
            apiSecretKey: apiSecretKey,
            apiKeyID: apiKeyID,
            configuration: [
                // "fonts": customFont,
                "colors": color,
                // "images": img,
                // "language": lang
            ]
        )
        
        // Granting user permission using notification center
        UNUserNotificationCenter.current() // 1
        .requestAuthorization(options: [.alert, .sound, .badge]) { // 2
          granted, error in
            print("Permission granted: \(granted)") // 3

            guard granted else { return }
            UNUserNotificationCenter.current().getNotificationSettings { settings in
                print("Notification settings: \(settings)")
                guard settings.authorizationStatus == .authorized else { return }
                DispatchQueue.main.async {
                  UIApplication.shared.registerForRemoteNotifications()
                }
            }
        }

        return true
    }
    
    func application(
      _ center: UNUserNotificationCenter,
      didReceive response: UNNotificationResponse,
      withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        print("\n\n\n called here \n\n\n\n")
        if response.actionIdentifier ==  UNNotificationDefaultActionIdentifier {
            print("actionIdentifier is UNNotificationDefaultActionIdentifier")
            print(response.notification.request.content)
        } else {
            print("actionIdentifier is not UNNotificationDefaultActionIdentifier")
            print(response)
        }
        
        // handle opened aps here from foreground or background
        completionHandler()
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}
