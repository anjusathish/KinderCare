//
//  OnBoardingServiceManager.swift
//  Kinder Care
//
//  Created by CIPL0668 on 04/02/20.
//  Copyright © 2020 Athiban Ragunathan. All rights reserved.
//

import Foundation

enum ContentType : String {
    case formData = "multipart/form-data"
    case json = "application/json"
}

enum OnBoardingServiceManager {
    
    
    case login(_ username : String, password : String, rememberMe : Int)
    case forgotPassword(_email:String)
    case resetPassword(_password:String,_confirm_password:String,_otp:String)
    case schoolList
    case dashboardCount(instituteID:String, school_id : Int)
    case adminDashboard
    case childName
    case activityDashboard(studentId:String,fromDate:String,toDate:String,type:String)
    case permission
    
    
    
    var scheme: String {
        switch self {
        case .login: return API.scheme
        case .forgotPassword,.resetPassword,.schoolList,.dashboardCount,.adminDashboard,.childName,.activityDashboard,.permission :return API.scheme
            
            
        }
    }
    var host: String {
        switch self {
        case .login : return API.baseURL
        case .forgotPassword(_),.resetPassword(_),.schoolList,.dashboardCount(_),.adminDashboard,.childName,.activityDashboard(_),.permission: return API.baseURL
        }
    }
    
    var port:Int{
        switch self {
        case .login(_),.forgotPassword(_),.resetPassword(_),.schoolList,.dashboardCount(_),.adminDashboard,.childName,.activityDashboard(_),.permission: return API.port
        }
    }
    var path: String {
        switch self {
            
        case .login(_) : return API.path + "/user/login"
        case .forgotPassword(_):return API.path + "/user/forgot/password"
        case .resetPassword(_):return API.path + "/user/update/password"
        case .schoolList:return API.path + "/superadmin/school/list"
        case .dashboardCount(let instituteID,_):return API.path + "/superadmin/institute_details/\(instituteID)"
        case .adminDashboard: return API.path + "/superadmin/admindashboard"
        case .childName: return API.path + "/parent/familyinformation/childlist"
            
        case .activityDashboard(let studentID,_,_,_): return API.path + "/activity/student/" + studentID + "/list"
        case .permission: return API.path + "/getPermission"
            
        }
    }
    
    var method: String {
        switch self {
        case .login(_): return "POST"
        case .forgotPassword(_),.resetPassword(_): return "POST"
        case .schoolList,.childName:return "GET"
        case .dashboardCount(_):return "POST"
        case .adminDashboard,.activityDashboard(_),.permission: return "GET"
        }
    }
    
   // "https://omni.com//user/login/id=123&color=1756237615"
    
    var parameters: [URLQueryItem]? {
        switch self {
        case .login(_),.forgotPassword(_),.resetPassword(_),.schoolList,.dashboardCount(_),.adminDashboard,.childName,.permission:
            return nil
            
        case .activityDashboard(let studentId,let date_from,let date_to,let type):
            
            return [URLQueryItem(name: "student_id", value: studentId),
                    URLQueryItem(name: "date_from", value: date_from),
                    URLQueryItem(name: "date_to", value: date_to),
                    URLQueryItem(name: "type", value: type)]
            
            
        }
    }
    var headerFields: [String : String]
    {
        switch self {
        case .login(_),.forgotPassword(_),.resetPassword(_),.schoolList,.dashboardCount(_),.adminDashboard,.childName,.activityDashboard(_),.permission:
            return ["API_VERSION" : "1.0", "DEVICE_TYPE" : "iOS"]
        }
    }
    
    var body: Data? {
        switch self {
            
        case .login,.forgotPassword,.resetPassword,.schoolList,.dashboardCount(_),.adminDashboard,.childName,.activityDashboard(_),.permission: return nil
            
        }
    }
    
    var formDataParameters : [String : Any]? {
        
        switch self {
            
        case .login(let username, let password, let rememberMe) :
            
            let parameters = ["email" : username,
                              "password" : password,
                              "remember_me": rememberMe] as [String : Any]
            return parameters
            
        case .forgotPassword(let _email):
            let parameters = ["email" : _email] as [String : Any]
            return parameters
            
        case .resetPassword(let _password,let _confirm_password,let _otp):
            
            let parameters = ["password" : _password,"confirm_password":_confirm_password,"otp":_otp] as [String : Any]
            return parameters
        case .dashboardCount(_, let school_id):
            let parameters = ["school_id" : school_id] as [String : Any]
            return parameters
        case .schoolList,.childName :
            return nil
            
        case .adminDashboard,.activityDashboard(_),.permission: return nil
            
        }
    }
}


