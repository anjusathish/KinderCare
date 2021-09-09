//
//  RootViewController.swift
//  Kinder Care
//
//  Created by CIPL0681 on 11/11/19.
//  Copyright © 2019 Athiban Ragunathan. All rights reserved.
//

import UIKit
import RESideMenu

class RootViewController: RESideMenu {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
  }
  
  override func awakeFromNib() {
    
    if  let userType = UserManager.shared.currentUser?.userType {
      if let _type = UserType(rawValue:userType ) {
        
        if  _type.rawValue == 5 {
          self.contentViewController = UIStoryboard.dashboardStoryboard().instantiateViewController(withIdentifier: "DashboardVC")
        }
          
        else{
          self.contentViewController = UIStoryboard.commonDashboardStoryboard().instantiateViewController(withIdentifier: "CommonDashboardVC")
        }
      }
    }
    
    self.leftMenuViewController = UIStoryboard.onBoardingStoryboard().instantiateViewController(withIdentifier: "leftMenuViewController")
    
    backgroundImage = UIImage(named: "BG")
    
  }
  
  
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destination.
   // Pass the selected object to the new view controller.
   }
   */
  
}
