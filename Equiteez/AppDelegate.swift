//
//  AppDelegate.swift
//  Equiteez
//
//  Created by Aniruddha Prabhu on 1/7/20.
//  Copyright © 2020 Aniruddha Prabhu. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
@available(iOS 13.0, *)
class AppDelegate: UIResponder, UIApplicationDelegate {

    var enableAllOrientation = true
    var orientationLock = UIInterfaceOrientationMask.all

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        do {
            let count = try PersistentService.context.fetch(Transfer.getSortedFetchRequest()).count
            if count == 0 {
                let initialBalance = Transfer(context: PersistentService.context)
                initialBalance.walletBalance = 10000
                initialBalance.dateUpdated = Double(Date().timeIntervalSince1970)
                
                PersistentService.saveContext()
            }
            
//            // Temporary code for adding missing CoreData values on bootup
//            let stocks = try PersistentService.context.fetch(Stock.getSortedFetchRequest())
//            print("stocks count: \(stocks.count)")
//            for stk in stocks {
//
//                FMPquery.getProfile(symbol: stk.symbol!) { (tick, mkcp, avgv, pchg, cmpn, cmpi, cmpw, cmpd, cmpc, cmpl, cmpe) in
//
//                    stk.onWatchlist = true
//                    stk.companyEmployees = cmpe
//                    PersistentService.saveContext()
//
//                }
//            }
            
            UserDefaults.standard.set(false, forKey: "watchlistSet")
            UserDefaults.standard.set(false, forKey: "portfolioIsSet")
            UserDefaults.standard.set(false, forKey: "chartIsSet")
        } catch { print(error) }
        
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
    
    func applicationWillTerminate(_ application: UIApplication) {
        PersistentService.saveContext()
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return self.orientationLock
    }
    
    struct AppUtility {
        static func lockOrientation(_ orientation: UIInterfaceOrientationMask) {
            
            if let delegate = UIApplication.shared.delegate as? AppDelegate {
                delegate.orientationLock = orientation
            }
        }
        
        /// OPTIONAL Added method to adjust lock and rotate to the desired orientation
        static func lockOrientation(_ orientation: UIInterfaceOrientationMask, andRotateTo rotateOrientation:UIInterfaceOrientation) {
            self.lockOrientation(orientation)
            UIDevice.current.setValue(rotateOrientation.rawValue, forKey: "orientation")
        }
    }
}

