//
//  NotificationServiceManager.swift
//  Kinder Care
//
//  Created by CIPL0668 on 24/02/20.
//  Copyright © 2020 Athiban Ragunathan. All rights reserved.
//

import Foundation

enum NotificationServiceManager {
    
    
    case getNotification(_ school_id :Int,student_id:Int)
    case clearAll(school_id:Int,student_id:Int)
    
    
    var scheme: String {
        switch self {
        case .getNotification(_),.clearAll(_) :return API.scheme
            
            
        }
    }
    var host: String {
        switch self {
        case .getNotification(_),.clearAll(_): return API.baseURL
        }
    }
    
    var port:Int{
        switch self {
        case .getNotification(_),.clearAll(_): return API.port
        }
    }
    var path: String {
        switch self {
            
        case .getNotification(_) : return API.path + "/superadmin/notification"
        case .clearAll(_): return API.path + "/superadmin/notification/clearall"
            
        }
    }
    
    var method: String {
        switch self {
        case .getNotification(_),.clearAll: return "POST"
            
        }
    }
    
    var parameters: [URLQueryItem]? {
        switch self {
        case .getNotification(_),.clearAll(_):
            return nil
            
            
        }
    }
    var headerFields: [String : String]
    {
        switch self {
        case .getNotification(_),.clearAll(_):
            return ["API_VERSION" : "1.0", "DEVICE_TYPE" : "iOS"]
        }
    }
    
    var body: Data? {
        switch self {
            
        case .getNotification(_),.clearAll(_): return nil
            
        }
    }
    
    var formDataParameters : [String : Any]? {
        
        switch self {
            
        case .clearAll(let school_id,let student_id):
            let parameters = ["school_id" : school_id,"student_id":student_id] as [String : Any]
            return parameters
            
        case .getNotification(let school_id,let student_id):
            let parameters = ["school_id" : school_id,"student_id":student_id] as [String : Any]
            return parameters
            
        }
    }
}

