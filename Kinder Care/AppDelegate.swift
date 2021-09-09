//
//  AppDelegate.swift
//  Kinder Care
//
//  Created by Athiban Ragunathan on 06/11/19.
//  Copyright © 2019 Athiban Ragunathan. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  override init() {
    super.init()
    UIFont.overrideInitialize()
  }
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    IQKeyboardManager.shared.enable = true
    
    if UserManager.shared.isLoggedInUser() {
      let vc = UIStoryboard.onBoardingStoryboard().instantiateViewController(withIdentifier: "RootViewController")
      let nc = UINavigationController(rootViewController: vc)
      nc.isNavigationBarHidden = true
      window?.rootViewController = nc
    }
    
    return true
  }
  
  func applicationWillTerminate(_ application: UIApplication) {
    print("ApplicationWillTerminate")
  }
  
  func applicationDidEnterBackground(_ application: UIApplication) {
    print("ApplicationDidEnterBackground")
  }
  
  // MARK: - DEV METHODS
  class func getAppdelegateInstance() -> AppDelegate?{
    let appDelegateRef = UIApplication.shared.delegate as! AppDelegate
    return appDelegateRef
  }
}

