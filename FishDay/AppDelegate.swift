//
//  AppDelegate.swift
//  FishDay
//
//  Created by Muhammad Kamal on 2/17/18.
//  Copyright © 2018 Anas Sherif. All rights reserved.
//

import UIKit
import CoreData
import GooglePlaces
import GoogleMaps
import MOLH
import AppsFlyerLib
import OneSignal


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, AppsFlyerTrackerDelegate, OSPermissionObserver {
    

    var window: UIWindow?

    @objc func sendLaunch(app:Any) {
        AppsFlyerTracker.shared().trackAppLaunch()
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        MOLH.shared.activate(true)
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        if UserDefUtil.contains(key: Constant.USER) {
            setHomeAsRoot()
        }else{
            setLoginAsRoot()
        }
        
        
        self.window?.makeKeyAndVisible()
        
        GMSPlacesClient.provideAPIKey("")
        GMSServices.provideAPIKey("")
        
        AppsFlyerTracker.shared().appsFlyerDevKey = ""
        AppsFlyerTracker.shared().appleAppID = ""
        AppsFlyerTracker.shared().delegate = self
        /* Set isDebug to true to see AppsFlyer debug logs */
        AppsFlyerTracker.shared().isDebug = true

        NotificationCenter.default.addObserver(self,
        selector: #selector(sendLaunch),
        // For Swift version < 4.2 replace name argument with the commented out code
        name: UIApplication.didBecomeActiveNotification, //.UIApplicationDidBecomeActive for Swift < 4.2
        object: nil)

        AppsFlyerTracker.shared().disableIAdTracking = true
        
        if #available(iOS 13.0, *) {
            window!.overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        
        //START OneSignal initialization code
        let onesignalInitSettings = [kOSSettingsKeyAutoPrompt: false, kOSSettingsKeyInAppLaunchURL: false]
        
        // Replace 'YOUR_ONESIGNAL_APP_ID' with your OneSignal App ID.
        OneSignal.initWithLaunchOptions(launchOptions,
          appId: "",
          handleNotificationAction: nil,
          settings: onesignalInitSettings)

        OneSignal.inFocusDisplayType = OSNotificationDisplayType.notification;

        // The promptForPushNotifications function code will show the iOS push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission (See step 6)
        OneSignal.promptForPushNotifications(userResponse: { accepted in
          print("User accepted notifications: \(accepted)")
        })
        //END OneSignal initializataion code
        
        // Add your AppDelegate as an obsserver
        OneSignal.add(self as? OSPermissionObserver)
        self.getOneSignalNotiToken()
       
        return true
    }
    
    func getOneSignalNotiToken() {
        let status: OSPermissionSubscriptionState = OneSignal.getPermissionSubscriptionState()

        let hasPrompted = status.permissionStatus.hasPrompted
        print("hasPrompted = \(hasPrompted)")
        let userStatus = status.permissionStatus.status
        print("userStatus = \(userStatus)")

        
        let userID = status.subscriptionStatus.userId
        print("userID = \(userID ?? "")")
        let userDefaults = UserDefaults()
        userDefaults.set(userID, forKey: Constant.PUSH_TOKEN)
    }
    
    // Add this new method
    func onOSPermissionChanged(_ stateChanges: OSPermissionStateChanges!) {
       // Example of detecting answering the permission prompt
       if stateChanges.from.status == OSNotificationPermission.notDetermined {
          if stateChanges.to.status == OSNotificationPermission.authorized {
             print("Thanks for accepting notifications!")
            
          } else if stateChanges.to.status == OSNotificationPermission.denied {
             print("Notifications not accepted. You can turn them on later under your iOS settings.")
          }
       }
       // prints out all properties
       print("PermissionStateChanges: \n\(stateChanges)")
    }
    
    func setLoginAsRoot(){
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController: LoginViewController = mainStoryboard.instantiateViewController(withIdentifier: "Login") as! LoginViewController
        self.window?.rootViewController = loginViewController
        self.window?.makeKeyAndVisible()
    }
    
    func setHomeAsRoot() {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        let mainNavigationController: SWRevealViewController = mainStoryboard.instantiateViewController(withIdentifier: "Main") as! SWRevealViewController
//        mainNavigationController.setRear(nil, animated: true)
////        mainNavigationController.setRight(<#T##rightViewController: UIViewController!##UIViewController!#>, animated: <#T##Bool#>)
//        self.window?.rootViewController = mainNavigationController
        
        
        let mainRevealController = SWRevealViewController()
        
        let menu = mainStoryboard.instantiateViewController(withIdentifier:"MenuViewController")
        
        let homepage = mainStoryboard.instantiateViewController(withIdentifier: "MainNavigationController")
                
        mainRevealController.frontViewController = homepage
        if MOLHLanguage.isArabic() {
            mainRevealController.rightViewController = menu
            MOLH.setLanguageTo("ar")
        } else {
            mainRevealController.rearViewController = menu
            MOLH.setLanguageTo("en")
        }
        
//        revealController.delegate = self
//        mainRevealController  = revealController
        
        self.window?.rootViewController = mainRevealController
        
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
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "FishDay")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    
    // Deeplinking

     // Open URI-scheme for iOS 9 and above
     func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
//         AppsFlyerTracker.shared().handleOpen(url, options: options)
        
        return true
     }

     // Open URI-scheme for iOS 8 and below
     func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
       AppsFlyerTracker.shared().handleOpen(url, sourceApplication: sourceApplication, withAnnotation: annotation)
        
        print("1111111111:  this is I don't know")
       return true
     }

     // Open Univerasal Links
     // For Swift version < 4.2 replace function signature with the commented out code
     // func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool { // this line for Swift < 4.2
     func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        
        guard let url = userActivity.webpageURL else {return false}
        
        let url_path = url.path;
        let psth_strArr = url_path.split(separator: "/")
        let productId: String = String(psth_strArr[psth_strArr.count - 1])
        if(productId == "appurwaycallback") {
            if let nav = self.window?.rootViewController?.children {
                nav.forEach { vc in
                    if let viewControllers = vc as? UINavigationController {
                        viewControllers.children.forEach { vc in
                            if let x = vc as? CompleteOrderViewController {
                                x.callbackPayment()
                            } else if let x = vc as? ConfirmationViewController {
                                x.callbackPayment()
                            }
                        }
                    }
                }
            }
        } else {
            if UserDefUtil.contains(key: Constant.USER) {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let homepage = storyboard.instantiateViewController(withIdentifier: "MainNavigationController") as? UINavigationController
                let productDetailsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProductDetailsViewController") as? ProductDetailsViewController
                productDetailsViewController!.productId = productId
                homepage?.pushViewController(productDetailsViewController!, animated: true)
                let navController = self.window?.rootViewController as? SWRevealViewController
                if(navController != nil) {
                    navController!.frontViewController = homepage
                    
                } else {
                }
            } else {
                let loginViewController = self.window?.rootViewController as? LoginViewController
                loginViewController?.universal_link_productId = productId
            }
        }
        
         AppsFlyerTracker.shared().continue(userActivity, restorationHandler: nil)
        
         return true
     }

     // Report Push Notification attribution data for re-engagements
     func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
         AppsFlyerTracker.shared().handlePushNotification(userInfo)
     }

     // AppsFlyerTrackerDelegate implementation

     //Handle Conversion Data (Deferred Deep Link)
     func onConversionDataSuccess(_ data: [AnyHashable: Any]) {
         print("\(data)")
         if let status = data["af_status"] as? String{
             if(status == "Non-organic"){
                 if let sourceID = data["media_source"] , let campaign = data["campaign"]{
                     print("This is a Non-Organic install. Media source: \(sourceID)  Campaign: \(campaign)")
                 }
             } else {
                 print("This is an organic install.")
             }
             if let is_first_launch = data["is_first_launch"] , let launch_code = is_first_launch as? Int {
                 if(launch_code == 1){
                     print("First Launch")
                 } else {
                     print("Not First Launch")
                 }
             }
         }
     }
     func onConversionDataFail(_ error: Error) {
        print("\(error)")
     }

     //Handle Direct Deep Link
    func onAppOpenAttribution(_ attributionData: [AnyHashable: Any]) {
         //Handle Deep Link Data
         print("onAppOpenAttribution data:")
         for (key, value) in attributionData {
             print(key, ":",value)
         }
     }
     func onAppOpenAttributionFailure(_ error: Error) {
         print("\(error)")
     }

//     // support for scene delegate
//     // MARK: UISceneSession Lifecycle
//     @available(iOS 13.0, *)
//     func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
//         // Called when a new scene session is being created.
//         // Use this method to select a configuration to create the new scene with.
//         return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
//     }
//     @available(iOS 13.0, *)
//     func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
//         // Called when the user discards a scene session.
//         // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
//         // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
//     }

}

