//
//  ReportServiceManager.swift
//  Kinder Care
//
//  Created by CIPL0590 on 2/20/20.
//  Copyright © 2020 Athiban Ragunathan. All rights reserved.
//

import Foundation


enum ReportServiceManager {
    
    case workingDaysCount(usertype_id:Int,fromdate:String,todate:String,school_id:Int,class_id:Int,section:Int)
    case salaryFilter(usertype_id:Int,fromdate:String,todate:String,school_id:Int)
    case salaryExport(usertype:Int,fromdate:String,todate:String,school_id:Int)
    
    case studentExport(usertype_id:Int,fromdate:String,todate:String,school_id:Int,class_id:Int,section:Int)
    case staffExport(usertype_id:Int,fromdate:String,todate:String,school_id:Int)
    
    var scheme: String {
        switch self {
        case .workingDaysCount(_),.salaryFilter(_),.salaryExport(_),.studentExport(_),.staffExport(_): return API.scheme
            
            
        }
    }
    var host: String {
        switch self {
        case .workingDaysCount(_),.salaryFilter(_),.salaryExport(_),.studentExport(_),.staffExport(_): return API.baseURL
            
        }
    }
    
    var path: String {
        switch self {
            
        case .workingDaysCount(_) : return API.path + "/superadmin/workingdays/count"
        case .salaryFilter(_):return  API.path + "/superadmin/report/salaryfilter"
        case .salaryExport(_) : return API.path + "/staff_salary_export"
        case .studentExport(_) :return API.path + "/student_attendance_export"
        case .staffExport(_) : return API.path + "/staff_attendance_export"
            
            
            
        }
    }
    
    var method: String {
        switch self {
        case .workingDaysCount(_),.salaryFilter(_),.salaryExport(_),.studentExport(_),.staffExport(_): return "POST"
            
            
            
        }
    }
    var port:Int{
        switch self {
        case .workingDaysCount(_),.salaryFilter(_),.salaryExport(_),.studentExport(_),.staffExport(_): return API.port
            
        }
    }
    var parameters: [URLQueryItem]? {
        switch self {
        case .workingDaysCount(_),.salaryFilter(_),.salaryExport(_),.studentExport(_),.staffExport(_):
            return nil
        }
    }
    
    var body: Data? {
        switch self {
            
        case .workingDaysCount(_),.salaryFilter(_),.salaryExport(_),.studentExport(_),.staffExport(_): return nil
            
        }
    }
    var headerFields: [String : String]
    {
        switch self {
        case .workingDaysCount(_),.salaryFilter(_),.salaryExport(_),.studentExport(_),.staffExport(_):
            return ["API_VERSION" : "1.0", "DEVICE_TYPE" : "iOS"]
        }
    }
    
    var formDataParameters : [String : Any]? {
        
        switch self {
        case .workingDaysCount(let usertype_id, let from_date, let to_date,let school_id,let className,let section) :
            
            let parameters = ["usertype_id" : usertype_id,
                              "fromdate" : from_date,
                              "todate": to_date,
                              "school_id":school_id,
                              "class_id":className,
                              "section":section] as [String : Any]
            return parameters
            
            
        case .salaryFilter(let usertype_id,let fromdate, let todate,let school_id):
            let parameters = ["usertype_id" : usertype_id,
                              "fromdate" : fromdate,
                              "todate": todate,
                              "school_id":school_id] as [String : Any]
            return parameters
            
            
        case .salaryExport(let usertype,let fromdate,let todate,let school_id):
            let parameters = ["user_type" : usertype,
                              "fromdate" : fromdate,
                              "todate": todate,
                              "school_id":school_id] as [String : Any]
            return parameters
            
        case .studentExport(let usertype_id,let fromdate,let todate, let school_id,let class_id,let section):
            
            let parameters = ["usertype_id" : usertype_id,
                              "fromdate" : fromdate,
                              "todate": todate,
                              "school_id":school_id,
                              "class_id":class_id,
                              "section":section] as [String : Any]
            return parameters
            
            
        case  .staffExport(let usertype_id, let fromdate,let todate, let school_id):
            
            let parameters = ["usertype_id" : usertype_id,
                              "fromdate" : fromdate,
                              "todate": todate,
                              "school_id":school_id] as [String : Any]
            return parameters
            
        }
        
        
    }
}
