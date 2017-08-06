//
//  AppDelegate.swift
//  NYPITP312
//
//  Created by Alex Ooi on 24/4/17.
//  Copyright © 2017 NYP. All rights reserved.
//

import UIKit
import Firebase
import OAuthSwift
import FBSDKCoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FIRApp.configure()
        
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        var configureError: NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        assert(configureError == nil, "Error configuring Google services: \(configureError)")
        
        GIDSignIn.sharedInstance().clientID = FIRApp.defaultApp()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        
        return true
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        if let error = error {
            print("\(error.localizedDescription)")
            // [START_EXCLUDE silent]
            NotificationCenter.default.post(
                name: Notification.Name(rawValue: "ToggleAuthUINotification"), object: nil, userInfo: nil)
            // [END_EXCLUDE]
        } else {
            // Perform any operations on signed in user here.
            let userId = user.userID                  // For client-side use only!
            let idToken = user.authentication.idToken // Safe to send to the server
            let accessToken = user.authentication.accessToken
            let fullName = user.profile.name
            let givenName = user.profile.givenName
            let familyName = user.profile.familyName
            let email = user.profile.email
            
            let credential = FIRGoogleAuthProvider.credential(withIDToken: idToken!, accessToken: accessToken!)
            
            DispatchQueue.global(qos: .background).async {
                HTTP.postJSON(url: "http://13.228.39.122/FP01_654265348176237/1.0/user/login", json: JSON.init(parseJSON: "{ \"type\": \"G\", \"token\": \"\(accessToken!)\" }"), onComplete: {
                    json, response, error in
                    
                    if json == nil {
                        return
                    }

                    let nav: RootNavViewController = self.window?.rootViewController as! RootNavViewController
                    let login = Login()
                    login.email = email
                    login.name = json!["name"].string!
                    login.photo = json!["photo"].string!
                    login.token = json!["token"].string!
                    login.userId = json!["userid"].string!
                    login.type = json!["type"].string!
                    nav.login = login
                    
                    do {
                        let data = try Data(contentsOf: URL(string: "http://13.228.39.122/fpsatimgdev/loadimage.aspx?q=users/\(login.photo!)_c300")!)
                        let profilePic = UIImage(data: data)!
                        
                        FIRAuth.auth()?.signIn(with: credential, completion: {
                            (user, error) in
                            if error == nil {
                                let userInfo = ["email": email]
                                UserDefaults.standard.set(userInfo, forKey: "userInformation")
                                print("Successfully logged into Firebase")
                                
                                let storageRef = FIRStorage.storage().reference().child("usersProfilePics").child(user!.uid)
                                let imageData = UIImageJPEGRepresentation(profilePic, 0.1)
                                storageRef.put(imageData!, metadata: nil, completion: { (metadata, err) in
                                    if err == nil {
                                        let path = metadata?.downloadURL()?.absoluteString
                                        let values = ["name": login.name, "email": email, "profilePicLink": path!, "azureId": login.userId]
                                        FIRDatabase.database().reference().child("users").child(user!.uid).child("credentials").updateChildValues(values, withCompletionBlock: { (errr, _) in
                                            if errr == nil {
                                                let userInfo = ["email" : email]
                                                UserDefaults.standard.set(userInfo, forKey: "userInformation")
                                                //completion(true)
                                            }
                                        })
                                    }
                                })
                                
                                FIRDatabase.database().reference().child("bookmarks").child((FIRAuth.auth()?.currentUser?.uid)!).observeSingleEvent(of: .value, with: {
                                    (snapshot) in
                                    if snapshot.exists() {
                                        if snapshot.value != nil {
                                            let bookmarks = snapshot.value as! [String: Bool]
                                            var bookmarkList: [String] = []
                                            for bookmark in bookmarks {
                                                bookmarkList.append(bookmark.key)
                                            }
                                            UserDefaults.standard.set(bookmarkList, forKey: "bookmarks")
                                        }
                                        DispatchQueue.main.async {
                                            nav.popToRootViewController(animated: true)
                                        }
                                    }
                                })
                            } else {
                                print("Failed to log in to firebase with google account")
                            }
                        })
                    } catch {
                        print("Couldn't get the photo")
                    }
                    
                })
            }
            
            // [START_EXCLUDE]
            NotificationCenter.default.post(
                name: Notification.Name(rawValue: "ToggleAuthUINotification"),
                object: nil,
                userInfo: ["statusText": "Signed in user:\n\(fullName)"])
            // [END_EXCLUDE]
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // [START_EXCLUDE]
        NotificationCenter.default.post(
            name: Notification.Name(rawValue: "ToggleAuthUINotification"),
            object: nil,
            userInfo: ["statusText": "User has disconnected."])
        // [END_EXCLUDE]
    }
    
    func application(_ application: UIApplication,
                     open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        let facebookDidHandle = FBSDKApplicationDelegate.sharedInstance().application(
            application,
            open: url,
            sourceApplication: sourceApplication,
            annotation: annotation)
        
        let googleDidHandle = GIDSignIn.sharedInstance().handle(url,
                                                 sourceApplication: sourceApplication,
                                                 annotation: annotation)
        
        
        return googleDidHandle || facebookDidHandle
    }
    
    @available(iOS 9.0, *)
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool {
        
        let facebookDidHandle = FBSDKApplicationDelegate.sharedInstance().application(app, open: url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
        
        let googleDidHandle = GIDSignIn.sharedInstance().handle(url,
                                                                sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,
                                                                annotation: options[UIApplicationOpenURLOptionsKey.annotation])
        
        return googleDidHandle || facebookDidHandle
        
        /*if (url.host == "oauth-callback") {
            OAuthSwift.handle(url: url)
            return true
        } else {
            return GIDSignIn.sharedInstance().handle(url,
                                                     sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,
                                                     annotation: options[UIApplicationOpenURLOptionsKey.annotation])
        }*/
        
        //Setting default color for the navigation bar 
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: UIBarPosition.any, barMetrics: UIBarMetrics.default)
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().barTintColor = UIColor(red: 0.251, green: 0.1608, blue: 0.5255, alpha: 1.0)
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().clipsToBounds = false
        UINavigationBar.appearance().backgroundColor = UIColor(red: 0.251, green: 0.1608, blue: 0.5255, alpha: 1.0)
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        
        
        UIApplication.shared.setStatusBarStyle(UIStatusBarStyle.lightContent, animated: true)

        
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
        //AppEventsLogger.activate(application)
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        User.logOutUser { (status) in
            if status == true {
                //self.dismiss(animated: true, completion: nil)
                print("Successfully logged out of Firebase")
            }
        }
    }

}

