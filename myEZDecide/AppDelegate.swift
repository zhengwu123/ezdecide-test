//
//  AppDelegate.swift
//  myEZDecide
//
//  Created by Jiapei Liang on 2/22/17.
//  Copyright © 2017 liangjiapei. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit
import GoogleSignIn


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        //status bar color
        UIApplication.shared.statusBarStyle = .lightContent
        

        
        //Navigation bar color setting
        let navigationBar = UINavigationBar.appearance()
            navigationBar.tintColor = UIColor.white
            navigationBar.barTintColor = UIColor(red: CGFloat(112/255.0), green: CGFloat(130/255.0), blue: CGFloat(56/255.0), alpha: CGFloat(1))
            navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        

        
        // Override point for customization after application launch.
        
        // Use Firebase library to con∫figure APIs
        FIRApp.configure()
        
        // Google Login in init
        GIDSignIn.sharedInstance().clientID = FIRApp.defaultApp()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        if (FIRAuth.auth()?.currentUser != nil) {
            // User is logged in, do work such as go to next view controller.
            print("User is already logged in with Email")
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "EZDecideNavigationController")
            
            window?.rootViewController = vc
        }
        
        if (FBSDKAccessToken.current() != nil) {
            // User is logged in, do work such as go to next view controller.
            print("User is already logged in with FB")
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "EZDecideNavigationController")
            
            window?.rootViewController = vc
        }
        
        if (GIDSignIn.sharedInstance().currentUser != nil) {
            // User is logged in, do work such as go to next view controller.
            print("User is already logged in with Google")
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "EZDecideNavigationController")
            
            window?.rootViewController = vc
        }
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "UserDidLogoutNotification"), object: nil, queue: OperationQueue.main) { (Notification) in
            
            let firebaseAuth = FIRAuth.auth()
            do {
                try firebaseAuth?.signOut()
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateInitialViewController()
                
                self.window?.rootViewController = vc
                
                print("User has successfully logged out")
                
            } catch let signOutError as NSError {
                print ("Error signing out: %@", signOutError)
            }
        }
        
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
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
        let handled: Bool = FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation) || GIDSignIn.sharedInstance().handle(url,
                                                                                                                                                                                                             sourceApplication: sourceApplication,
                                                                                                                                                                                                             annotation: annotation)
        
        return handled
        
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        // ...
        if let error = error {
            // ...
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = FIRGoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                          accessToken: authentication.accessToken)
        // ...
        FIRAuth.auth()?.signIn(with: credential) { (user, error) in
            // ...
            if error != nil {
                // ...
                print(error?.localizedDescription)
                return
            }
            else{
                print("user signed in")
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "EZDecideNavigationController")
                
                self.window?.rootViewController = vc
                
                return
            }
        }
    }
    
    func signIn(signIn: GIDSignIn!, didDisconnectWithUser user:GIDGoogleUser!,
                withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
        let firebaseAuth = FIRAuth.auth()
        do {
            try firebaseAuth?.signOut()
            print("Successfully sign out with Google")
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
}

