//
//  WeeklyMenuServiceManager.swift
//  Kinder Care
//
//  Created by CIPL0590 on 3/11/20.
//  Copyright © 2020 Athiban Ragunathan. All rights reserved.
//

import Foundation

enum WeeklyMenuServiceManager {
  
  case courseType
  case menuItems(courseId : String, schoolId : String)
  case getWeeklyMenu(date: String, classId : String, schoolId : String,user_id:Int)
  case addWeeklyMenu(request : AddWeeklyMenuRequest)
  case editWeeklyMenu(request : AddWeeklyMenuRequest, _ weeklyMenuID: String)
  
  var scheme: String {
    switch self {
    case .courseType,.menuItems,.getWeeklyMenu,.addWeeklyMenu,.editWeeklyMenu :return API.scheme
    }
  }
  var host: String {
    switch self {
    case .courseType,.menuItems,.getWeeklyMenu,.addWeeklyMenu,.editWeeklyMenu: return API.baseURL
    }
  }
  
  var port:Int{
    switch self {
    case .courseType,.menuItems,.getWeeklyMenu,.addWeeklyMenu,.editWeeklyMenu: return API.port
    }
  }
  var path: String {
    switch self {
      
    case .courseType : return API.path + "/courseType/list"
    case .menuItems : return API.path + "/superadmin/presetfood/list"
    case .getWeeklyMenu: return API.path + "/superadmin/weeklyMenu/filter"
    case .addWeeklyMenu: return API.path + "/superadmin/weeklyMenu/mobile/add"
    case .editWeeklyMenu(_,let weeklyMenuID):  return API.path + "/superadmin/weeklyMenu/update/" + weeklyMenuID
      
    }
  }
  
  var method: String {
    switch self {
    case .courseType: return "GET"
    case .menuItems,.getWeeklyMenu,.addWeeklyMenu,.editWeeklyMenu: return "POST"
    }
  }
  
  var parameters: [URLQueryItem]? {
    switch self {
      
    case .courseType,.menuItems,.getWeeklyMenu,.addWeeklyMenu,.editWeeklyMenu: return nil
    }
  }
  var headerFields: [String : String]
  {
    switch self {
    case .courseType,.menuItems,.getWeeklyMenu,.addWeeklyMenu,.editWeeklyMenu:
      return ["Accept":"application/json", "API_VERSION" : "1.0", "DEVICE_TYPE" : "iOS"]
    }
  }
  
  var body: Data? {
    switch self {
    case .courseType,.menuItems,.getWeeklyMenu: return nil
    case .addWeeklyMenu(let request):
      let encoder = JSONEncoder()
      print(request)
      return try? encoder.encode(request)
    case .editWeeklyMenu(request: let request, _):
      let encoder = JSONEncoder()
      print(request)
      return try? encoder.encode(request)
    }
  }
  
  var formDataParameters : [String : Any]? {
    
    switch self {
      
    case .courseType,.addWeeklyMenu,.editWeeklyMenu: return nil
    case .menuItems(let courseId, let schoolId):
      
      return ["course_id" : courseId,
              "school_id" : schoolId]
      
    case .getWeeklyMenu(let date, let classId, let schoolId,let user_id):
      
      return ["date" : date,
              "school_id" : schoolId,
              "class":classId,
              "user_id":user_id]

    }
  }
}
