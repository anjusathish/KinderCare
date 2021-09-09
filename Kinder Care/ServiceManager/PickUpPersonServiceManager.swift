//
//  PickUpPersonServiceManager.swift
//  Kinder Care
//
//  Created by CIPL0590 on 2/14/20.
//  Copyright © 2020 Athiban Ragunathan. All rights reserved.
//

import Foundation

enum PickUpPersonServiceManager {
    
    case PickUpList(school_id:Int)
    case PickUpStatus(listId:String,status:String)
    
    var scheme: String {
        switch self {
        case .PickUpList(_): return API.scheme
        case .PickUpStatus(_): return API.scheme
            
        }
    }
    var host: String {
        switch self {
        case .PickUpList(_): return API.baseURL
        case .PickUpStatus(_): return API.baseURL
        }
    }
    
    var path: String {
        switch self {
            
            
            
        case .PickUpList(_):return API.path + "/superadmin/pp-approval/list"
            
        case .PickUpStatus(let listID,_):return API.path + "/superadmin/pp-change-status/" + listID
            
            
        }
    }
    
    var method: String {
        switch self {
        case .PickUpList(_):return "POST"
        case .PickUpStatus(_):return "POST"
            
        }
    }
    var port:Int{
        switch self {
        case .PickUpList(_): return API.port
        case .PickUpStatus(_): return API.port
            
        }
    }
    var parameters: [URLQueryItem]? {
        switch self {
        case .PickUpList(_):
            return nil
        case .PickUpStatus(_):
            return nil
        }
    }
    
    var body: Data? {
        switch self {
            
        case .PickUpList(_): return nil
        case .PickUpStatus(_): return nil
            
        }
    }
    var headerFields: [String : String]
    {
        switch self {
        case .PickUpList(_),.PickUpStatus(_):
            return ["Accept":"application/json","API_VERSION" : "1.0", "DEVICE_TYPE" : "iOS"]
        }
    }
    var formDataParameters : [String : Any]? {
        
        switch self {
            
        case .PickUpList(let school_id):
            let parameters = ["school_id" : school_id] as [String : Any]
            return parameters
            
        case .PickUpStatus(_, let status) :
            
            let parameters = ["status" : status] as [String : Any]
            
            return parameters
        }
    }
}
