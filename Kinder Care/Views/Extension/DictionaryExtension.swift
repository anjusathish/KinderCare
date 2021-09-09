//
//  DictionaryExtension.swift
//  Customer
//
//  Created by Athiban Ragunathan on 23/11/17.
//  Copyright © 2017 Athiban Ragunathan. All rights reserved.
//

import UIKit

extension UIStoryboard {
    
    /**
     Convenience Initializers to initialize storyboard.
     
     - parameter storyboard: String of storyboard name
     - parameter bundle:     NSBundle object
     
     - returns: A Storyboard object
     */
    convenience init(storyboard: String, bundle: Bundle? = nil) {
        self.init(name: storyboard, bundle: bundle)
    }
    
    /**
     Initiate view controller with view controller name.
     
     - returns: A UIView controller object
     */
    func instantiateViewController<T: UIViewController>() -> T {
        var fullName: String = NSStringFromClass(T.self)
        if let range = fullName.range(of: ".", options: .backwards) {
            fullName = String(fullName[range.upperBound...])
        }
        
        guard let viewController = self.instantiateViewController(withIdentifier: fullName) as? T else {
            fatalError("Couldn't instantiate view controller with identifier \(fullName) ")
        }
        
        return viewController
    }
    
    class func mainStoryboard() -> UIStoryboard {
        return UIStoryboard(name: "Main", bundle: nil)
    }
    
    class func dashboardStoryboard() -> UIStoryboard {
        return UIStoryboard(name: "ParentDashboard", bundle: nil)
    }
    
    class func commonDashboardStoryboard() -> UIStoryboard {
        return UIStoryboard(name: "Dashboard", bundle: nil)
    }
    
    class func applicationsStoryboard() -> UIStoryboard {
        return UIStoryboard(name: "Applications", bundle: nil)
    }
    class func FamilyInformationStoryboard() -> UIStoryboard {
        return UIStoryboard(name: "FamilyInformation", bundle: nil)
    }
    class func DailyActivityStoryboard() -> UIStoryboard {
        return UIStoryboard(name: "DailyActivity", bundle: nil)
    }
     class func AddActivityStoryboard() -> UIStoryboard {
        return UIStoryboard(name: "AddActivity", bundle: nil)
    }
    class func AddWeeklyMenuStoryboard() -> UIStoryboard {
           return UIStoryboard(name: "AddWeeklyMenu", bundle: nil)
       }
    class func onBoardingStoryboard() -> UIStoryboard {
        return UIStoryboard(name: "OnBoarding", bundle: nil)
    }
    
    class func messageStoryboard() -> UIStoryboard {
          return UIStoryboard(name: "Message", bundle: nil)
    }
    
    class func  paymentStoryboard() -> UIStoryboard {
        return UIStoryboard(name: "Payment", bundle: nil)
    }
    
    class func  attendanceStoryboard() -> UIStoryboard {
        return UIStoryboard(name: "Attendance", bundle: nil)
    }
    
    class func  leaveStoryboard() -> UIStoryboard {
        return UIStoryboard(name: "Leave", bundle: nil)
    }
    
    class func  profileStoryboard() -> UIStoryboard {
        return UIStoryboard(name: "Profile", bundle: nil)
    }
    
    class func popUpStoryboard() -> UIStoryboard {
        return UIStoryboard(name: "Popup", bundle: nil)
    }
    
    class func notificationStoryboard() -> UIStoryboard {
        return UIStoryboard(name: "Notification", bundle: nil)
    }
    
    class func calendarStoryboard() -> UIStoryboard {
          return UIStoryboard(name: "Calendar", bundle: nil)
    }
    
    class func reportsStoryboard() -> UIStoryboard {
        return UIStoryboard(name: "Reports", bundle: nil)
    }
    
    class func enrolmentEnquiryStoryboard() -> UIStoryboard {
           return UIStoryboard(name: "EnrolmentEnquiry", bundle: nil)
    }
    
    class func  compOffStoryboard() -> UIStoryboard {
        return UIStoryboard(name: "CompOff", bundle: nil)
    }
    
   
}

extension Dictionary {
    
    var queryString: String {
        var output: String = ""
        for (key,value) in self {
            output +=  "\(key)=\(value)&"
        }
        output = String(output.dropLast())
        return output
    }
}

extension NSDictionary {
    
    func containsObject(key : String) -> Bool {
        if (self.allKeys as NSArray).contains(key) {
            return true
        }
        else {
            return false
        }
    }
    
    func hasKey() -> Bool {
        return self.allKeys.count > 0 ? true : false
    }
}
