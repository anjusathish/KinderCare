//
//  ProfileServiceManager.swift
//  Kinder Care
//
//  Created by CIPL0668 on 06/02/20.
//  Copyright © 2020 Athiban Ragunathan. All rights reserved.
//

import Foundation

enum ProfileServiceManager {
    
    case getProfile(_ userID:String)
    
    case editProfile(_method : String, firstname : String, email : String, dob : String,contact : String, address : String,gender:String,instituteName:String)
    
    case changePassword(_method : String, firstName: String, email : String, old_password : String, password : String, Con_password : String,dob:String,gender:String,contact : String,instituteName:String,address:String)
    
    case changeProfilePic(_method : String, profilePic : UIImage)
    
    case listHealthStatus(from_date:String,to_date:String)
    case addHealthStatus(user_id:Int,temp:String,sanitizer:String,time:String)
    case deleteHealthStatus(id:String)
    case viewHealthStatus(id:String,date:String)
    
    
    
    
    var scheme: String {
        switch self {
        case .getProfile(_),.editProfile(_),.changePassword(_),.changeProfilePic(_),.listHealthStatus(_),.addHealthStatus(_),.deleteHealthStatus(_),.viewHealthStatus(_): return API.scheme
            
            
        }
    }
    
    var host: String {
        switch self {
        case .getProfile(_),.editProfile(_),.changePassword(_),.changeProfilePic(_),.listHealthStatus(_),.addHealthStatus(_),.deleteHealthStatus(_),.viewHealthStatus(_) : return API.baseURL
            
        }
    }
    
    var path: String {
        switch self {
            
        case .getProfile(let userid) : return API.path + "/userdetail/" + userid
        case .editProfile(_),.changePassword(_): return API.path + "/user/profile/update"
        case .changeProfilePic(_) : return API.path + "/user/profileImage/update"
            
        case .listHealthStatus(_):
            return API.path + "/list/health/status"
        case .addHealthStatus(_):
            return API.path + "/add/health/status"
        case .deleteHealthStatus(let id): return API.path + "/delete/health/status/" + id
        case .viewHealthStatus(let id,_):return API.path + "/view/health/status/" +  id
            
        }
    }
    
    var method: String {
        switch self {
        case .getProfile(_),.deleteHealthStatus(_): return "GET"
        case .editProfile(_),.changePassword(_),.changeProfilePic(_),.listHealthStatus(_),.addHealthStatus(_),.viewHealthStatus(_): return "POST"
            
        }
    }
    var port:Int{
        switch self {
        case .getProfile(_),.editProfile(_),.changePassword(_),.changeProfilePic(_),.listHealthStatus(_),.addHealthStatus(_),.deleteHealthStatus(_),.viewHealthStatus(_): return API.port
        }
    }
    var parameters: [URLQueryItem]? {
        switch self {
        case .getProfile(_),.editProfile(_),.changePassword(_),.changeProfilePic(_),.listHealthStatus(_),.addHealthStatus(_),.deleteHealthStatus(_),.viewHealthStatus(_):
            return nil
        }
    }
    
    var body: Data? {
        switch self {
            
        case .getProfile(_),.editProfile(_),.changePassword(_),.changeProfilePic(_),.listHealthStatus(_),.addHealthStatus(_),.deleteHealthStatus(_),.viewHealthStatus(_): return nil
            
        }
    }
    var headerFields: [String : String]
    {
        switch self {
        case .getProfile(_),.editProfile(_),.changePassword(_),.changeProfilePic(_),.listHealthStatus(_),.addHealthStatus(_),.deleteHealthStatus(_),.viewHealthStatus(_):
            return ["API_VERSION" : "1.0", "DEVICE_TYPE" : "iOS"]
        }
    }
    
    var formDataParameters : [String : Any]? {
        
        switch self {
            
        case .getProfile(_),.deleteHealthStatus(_) : return nil
            
        case .editProfile(let _method, let firstname, let email, let dob, let contact, let address,let gender,let instituteName):
            
            
            let parameters = ["_method" : _method,
                              "firstname" : firstname,
                              "email" : email,
                              "dob" : dob,
                              "address" : address,
                              "contact" : contact,
                              "gender":gender,
                              "institutename":instituteName] as [String : Any]
            
            return parameters
            
        case .changePassword(let _method, let firstName, let email, let old_password, let password, let Con_password,let dob,let gender,let contact,let instituteName,let address):
            
            let parameters = ["_method" : _method,
                              "firstname" : firstName,
                              "email" : email,
                              "old_password" : old_password,
                              "password" : password,
                              "confirm_password" : Con_password,
                              "dob":dob,
                              "gender":gender,
                              "contact":contact,
                              "institutename":instituteName,"address":address] as [String : Any]
            
            return parameters
            
        case .changeProfilePic(let _method, let profilePic) :
            
            let parameters = ["_method" : _method,
                              "profile" : profilePic] as [String : Any]
            
            return parameters
            
        case .listHealthStatus(let from_date, let to_date):
            let parameters = ["from_date":from_date,
                             "to_date":to_date] as [String:Any]
            return parameters
            
        case .addHealthStatus(let user_id, let temp, let sanitizer, let time):
            let parameters = ["user_id":user_id,
                             "temp":temp,"sanitizer":sanitizer,
                             "time":time] as [String:Any]
            return parameters
            
        case .viewHealthStatus(_,let date):
            let parameter = ["date":date]
            return parameter
        }
    }
}
