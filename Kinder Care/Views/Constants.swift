//
//  Constants.swift
//  iJob
//
//  Created by Athiban Ragunathan on 07/01/18.
//  Copyright © 2018 Athiban Ragunathan. All rights reserved.
//

import UIKit

struct REGEX {
    static let phone_indian = "^(?:(?:\\+|0{0,2})91(\\s*[\\-]\\s*)?|[0]?)?[789]\\d{9}$"
    static let email = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    static let phone_aus = "([(0),(+61)][23478]){0,1}[1-9][0-9]{7}"
  
}

struct AppFontName {
    static let regular = "BwSurcoDEMO-Regular"
    static let bold = "BwSurcoDEMO-Bold"
    static let semiBold = "BwSurcoDEMO-Medium"
    static let italic = "CourierNewPS-ItalicMT"
}

enum GrantType : String {
    case password = "password"
    case refreshToken = "refresh_token"
}

struct API {
    
    static let scope = "api1 offline_access"
    static let clientId = "ro.angular"
    static let clientSecret = "secret"
    static let baseURL = "app.kindercare.colanonline.in"
    static let scheme = "https"
    static let port = 8444
    static let path = "/public/api"
}
struct ImageURL {
    static let imageBasePath = "https://app.kindercare.colanonline.in/public/uploads/user/thumb/" // Need to check
}
extension API {
    
    static var fullBaseUrl : String {
        get {
            return API.scheme + "://" + API.baseURL
        }
    }
}

struct GOOGLE {
    static let placesAPI_KEY = "AIzaSyBqOCrPjA9IXTn8pHiNozi6cWI91oIetG0"
}

struct DEVICE {
    static let deviceType = "2"
   // static let uuid = KeychainManager.sharedInstance.getDeviceIdentifierFromKeychain()
    static let deviceModel = UIDevice.current.model
    static let systemVersion = UIDevice.current.systemVersion
    static let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
    static let buildNo = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "100"
}


class Constants: NSObject {
    static let shared = Constants()
    static let appDelegateRef : AppDelegate = AppDelegate.getAppdelegateInstance()!
    static var LAST_SELECTED_INDEX_N_PICKER = 0
    
    // Custom Date Picker
    class func viewControllerWithName(identifier: String) ->UIViewController {
           let storyboard = UIStoryboard(name: "Leave", bundle: nil)
           return storyboard.instantiateViewController(withIdentifier: identifier)
       }
    
//     func getCustomPickerInstance() -> CustomPicker{
//        let customPickerObj =   Constants.viewControllerWithName(identifier:"CustomPickerStoryboard") as! CustomPicker
//           return customPickerObj
//    }
    
    func getFilterInstance() -> FilterVC{
        let filterObj = Constants.viewControllerWithName(identifier:"FilterVC") as! FilterVC
           return filterObj
    }
    func getLeaveFilterInstance() -> LeaveApprovalFilterViewController{
        let filterObj = Constants.viewControllerWithName(identifier:"LeaveApprovalFilterViewController") as! LeaveApprovalFilterViewController
           return filterObj
    }
}

func showAlertView(title: String, msg: String, controller: UIViewController, okClicked: @escaping ()->()){
    let alertController = UIAlertController(title: title, message: msg, preferredStyle: UIAlertController.Style.alert)
    let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { (result : UIAlertAction) -> Void in
            print("OK")
            okClicked()
        }
        //alertController.view.tintColor = BASECOLOR
        alertController.addAction(okAction);
        controller.present(alertController, animated: true, completion: nil)
}
