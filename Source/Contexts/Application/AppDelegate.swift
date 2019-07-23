//
//  AppDelegate.swift
//  Lufa
//
//  Created by Konrad Belzowski on 15/03/2019.
//  Copyright © 2019 Konrad Belzowski. All rights reserved.
//

import UIKit
import CoreData
import Foundation
import GoogleMaps

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    static var sharedInstance: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    var window: UIWindow?

    lazy var windowController: WindowController? = {
        
        guard let window = window else {
            return nil
        }
        
        let wc = WindowController.init(window: window)

        return wc
    }()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        configureUserInterface()
        configureGoogleMaps()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        LocalRepositoryContext.sharedInstance.saveContext()
    }
    
    // MARK: Configurations
    func configureUserInterface() {
        
        window = UIWindow.init(frame: UIScreen.main.bounds)
        windowController?.presentLanguageController()
        window?.makeKeyAndVisible()
    }
    
    func configureGoogleMaps() {
        if !ConfigurationManager.sharedInstance.googleMapsProvided {
            guard let key = ConfigurationManager.sharedInstance.googleApiKey else {
                return
            }
            
            GMSServices.provideAPIKey(key)
            ConfigurationManager.sharedInstance.googleMapsProvided = true
        }
    }
    
    // MARK: User defaults
    func setAuthorizationToken(token: String, type: String) {
        UserDefaults.standard.set(type, forKey: "token_type")
        UserDefaults.standard.set(token, forKey: "access_token")
    }
    
    func removeAuthorizationToken() {
        UserDefaults.standard.removeObject(forKey: "token_type")
        UserDefaults.standard.removeObject(forKey: "access_token")
    }
    
    func getAuthorizationToken() -> String? {
        return UserDefaults.standard.object(forKey: "access_token") as? String
    }
    
    func getAuthorizationType() -> String? {
        return UserDefaults.standard.object(forKey: "token_type") as? String
    }
    
    func setAuthorizationOpenToken(token: String) {
        UserDefaults.standard.set(token, forKey: "access_open_token")
    }
    
    func removeAuthorizationOpenToken() {
        UserDefaults.standard.removeObject(forKey: "access_open_token")
    }
    
    func getAuthorizationOpenToken() -> String? {
        return UserDefaults.standard.object(forKey: "access_open_token") as? String
    }
    
    // MARK: - URL
    func openURL(address: String) {
        
        let url = URL(string: address)
        
        if let url = url, UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        
        let message = url.host?.removingPercentEncoding
        
        guard message == "authorizeCallback" else {
            return false
        }
        
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            return false
        }
        
        let code = components.queryItems?.first(where: {$0.name == "code"})?.value
        
        if let code = code {
            NotificationCenter.default.post(name: .authenticateDidFinish, object: code)
        }
        
        return true
    }
}
