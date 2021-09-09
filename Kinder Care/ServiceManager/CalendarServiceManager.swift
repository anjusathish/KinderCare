//
//  CalendarServiceManager.swift
//  Kinder Care
//
//  Created by CIPL0590 on 4/13/20.
//  Copyright © 2020 Athiban Ragunathan. All rights reserved.
//

import Foundation

enum CalendarServiceManager {
    
    case holidayList(month:Int,school_id:Int)
    
    
    var scheme: String {
        switch self {
        case .holidayList(_): return API.scheme
       
            
        }
    }
    var host: String {
        switch self {
        case .holidayList(_): return API.baseURL
            
        }
    }
    
    var path: String {
        switch self {
            
        case .holidayList(_) : return API.path + "/superadmin/holidayList/filter"
            
        
            }
    }
    
    var method: String {
        switch self {
        case .holidayList(_): return "POST"
            
        }
    }
    
    var port:Int{
        switch self {
        case .holidayList(_): return API.port
            
        }
    }
    
    var parameters: [URLQueryItem]? {
        switch self {
        case .holidayList(_):
            return nil
            
            
        }
    }
    
    var body: Data? {
        switch self {
            
        case .holidayList(_): return nil
            
        }
    }
    var headerFields: [String : String]
    {
        switch self {
        case .holidayList(_):
            return ["Accept":"application/json","API_VERSION" : "1.0", "DEVICE_TYPE" : "iOS"]
            
        }
    }
    
    var formDataParameters : [String : Any]? {
        
        switch self {
        case .holidayList(let month,let school_id) :
            
            let parameters = ["month" : month,"school_id":school_id] as [String : Any]
            return parameters
            
      
            
        
        }
    }
}

