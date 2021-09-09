//
//  AttendanceServiceManager.swift
//  Kinder Care
//
//  Created by CIPL0590 on 2/7/20.
//  Copyright © 2020 Athiban Ragunathan. All rights reserved.
//

import Foundation


//enum ContentType : String {
//    case formData = "multipart/form-data"
//    case json = "application/json"
//}

enum AttendanceServiceManager {
    
    
    case attendanceList(date : String,user_type :Int,school_id : Int)
    case classNameList(_schoolId:String)
    case sectionNameList(school_id:Int,class_id:Int)
    case sectionNameListSharedPreferrence(class_id:Int,schoolId:String)
    case studentAttendanceList(school_id:Int,date:String,section_id:Int,class_id:Int)
    case addAttendance(school_id:Int, selectedUsers : [Int],log_type:Int,date:String,time:String,user_type:Int,classId:Int?,sectionId:Int?)
    
    var scheme: String {
        switch self {
        case .attendanceList(_),.classNameList(_),.sectionNameList(_),.studentAttendanceList(_),.addAttendance(_),.sectionNameListSharedPreferrence(_): return API.scheme
        
    }
    }
    var host: String {
        switch self {
        case .attendanceList(_),.classNameList(_),.sectionNameList(_),.studentAttendanceList(_),.addAttendance(_),.sectionNameListSharedPreferrence(_) : return API.baseURL
        }
    }
    
    var port:Int{
        switch self {
        case .attendanceList(_),.classNameList(_),.sectionNameList(_),.studentAttendanceList(_),.addAttendance(_),.sectionNameListSharedPreferrence(_): return API.port
        }
    }
    var path: String {
        switch self {
            
        case .attendanceList(_) : return API.path + "/attendance/list"
        case .classNameList(_) :return API.path + "/classname/list"
        case .sectionNameList(_),.sectionNameListSharedPreferrence(_):return API.path + "/class/section/list"
        case .studentAttendanceList(_):return API.path + "/attendance/student/list"
        case .addAttendance(_):return API.path + "/attendance/add"
            
            
        }
    }
    
    var method: String {
        switch self {
        case .attendanceList(_): return "POST"
        case .classNameList(_): return "GET"
        case .sectionNameList(_),.sectionNameListSharedPreferrence(_):return "POST"
        case .studentAttendanceList(_) :return "POST"
        case .addAttendance:return "POST"
            
        }
    }
    
    var parameters: [URLQueryItem]? {
        switch self {
        case .attendanceList(_),.sectionNameList(_),.studentAttendanceList(_),.addAttendance,.sectionNameListSharedPreferrence(_):
            return nil
            
        case .classNameList(let schoolId):
            var  parametersArray : [URLQueryItem] = []
            parametersArray.append(contentsOf: [URLQueryItem(name:"school_id",value: schoolId)])
            return parametersArray
        }
    }
    var headerFields: [String : String]
    {
        switch self {
        case .attendanceList(_),.classNameList(_),.sectionNameList(_),.studentAttendanceList(_),.addAttendance,.sectionNameListSharedPreferrence(_):
            return ["API_VERSION" : "1.0", "DEVICE_TYPE" : "iOS"]
        }
    }
    
    var body: Data? {
        switch self {
            
        case .attendanceList(_),.classNameList(_),.sectionNameList(_),.studentAttendanceList(_),.addAttendance,.sectionNameListSharedPreferrence(_): return nil
            
        }
    }
    
    var formDataParameters : [String : Any]? {
        
        switch self {
            
        case .attendanceList(let date, let user_type, let school_id) :
            let parameters = ["date" : date,
                              "user_type" : user_type,
                              "school_id": school_id] as [String : Any]
            return parameters
            
        case .classNameList(_):
            return nil
        case .sectionNameListSharedPreferrence(let class_id,let schoolId):
            let parameter = ["class_id" : class_id,
                                      "school_id" : schoolId ] as [String:Any]
                     return parameter
        case .sectionNameList(let school_id,let class_id):
            let parameter = ["school_id":school_id,"class_id" : class_id] as [String:Any]
            return parameter
            
        case .studentAttendanceList(let school_id,let date,let section_id,let class_id):
            let parameters = ["school_id":school_id,"date":date,"section_id":section_id,"class_id":class_id] as [String : Any]
            return parameters
            
        case .addAttendance(let school_id, let selectedUsers, let log_type, let date, let time, let user_type, let classId, let sectionId):
            
            var parameters = ["school_id":school_id,
                              "user_id":selectedUsers,
                              "log_type":log_type,
                              "date":date,
                              "time":time,
                              "user_type":user_type] as [String : Any]
                        
            if let _classId = classId {
                parameters["class_id"] = _classId
            }
            
            if let _sectionId = sectionId {
                parameters["section_id"] = _sectionId
            }
            
            return parameters
        }
    }
}

