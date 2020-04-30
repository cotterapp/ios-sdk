//
//  AppDelegate.swift
//  CotterIOS
//
//  Created by albertputrapurnama on 02/01/2020.
//  Copyright (c) 2020 albertputrapurnama. All rights reserved.
//

import UIKit
import Cotter

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        guard let apiKeyID = Environment.shared.COTTER_API_KEY_ID else {
            print("Please set COTTER_API_KEY_ID in your XCode environment variables!")
            return false
        }
        guard let apiSecretKey = Environment.shared.COTTER_API_SECRET_KEY else {
            print("Please set COTTER_API_SECRET_KEY in your XCode environment variables!")
            return false
        }
        
        CotterWrapper.cotter = Cotter(
            apiSecretKey: apiSecretKey,
            apiKeyID: apiKeyID,
            cotterURL: "https://www.cotter.app/api/v0",
            userID: "",
            // configuration is an optional argument, remove this below and Cotter app will still function properly
            configuration: [:]
        )
        
        Cotter.configure(apiSecretKey: apiSecretKey, apiKeyID: apiKeyID)
        
        return true
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

