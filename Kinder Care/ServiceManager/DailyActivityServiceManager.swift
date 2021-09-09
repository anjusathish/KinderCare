//
//  ListActivityServiceManager.swift
//  Kinder Care
//
//  Created by CIPL0419 on 09/03/20.
//  Copyright © 2020 Athiban Ragunathan. All rights reserved.
//

import Foundation

enum DailyActivityServiceManager {
  
  case listDailyActivity(_ classId : String?, sectionId : String?, fromDate : String?, toDate:String?, page:String?)
  case viewDailyActivity(activity_id: Int)
  case updateDailyPhotoActivity(state: String,type: String, classID: Int,sectionID: Int,Description: String,studentID: [Int],attachmet:[URL],activity_id: Int)
  case addDailyActivityPhotoVideo(type: String, classID: Int,sectionID: Int,Description: String,studentID: [Int],attachmet:[URL],date:String)
  
  
  case addNapActivity(_ request: AddNapActivityRequest)
  case addMedicineActivity(_ request: AddMedicineActivityRequest)
  case addIncidentActivity(_ request: AddIncidentActivityRequest)
  case addClassRoomActivity(_ request: AddClassRoomActivityRequest)
  case addBathRoomActivity(_ request: AddBathRoomActivityRequest)
  case addMealActivity(_ request: AddMealActivityRequest)
  
  
  case clssRoomCategoryList
  case classroomMilestoneList
  case bathRoomTypeList
  
  case updateDailyActivityNap(_ request: UpdateDailyActivityRequest,_ activity_id: Int)
  case activityUpdate(_id:String,state:String)
  
  
  var scheme: String {
    switch self {
    case .listDailyActivity,.viewDailyActivity,.updateDailyPhotoActivity,.addDailyActivityPhotoVideo,.addNapActivity,.clssRoomCategoryList,.classroomMilestoneList,.addMedicineActivity,.addIncidentActivity,.bathRoomTypeList,.addClassRoomActivity,.addBathRoomActivity,.addMealActivity: return API.scheme
    case .updateDailyActivityNap,.activityUpdate: return API.scheme
      
    }
  }
  var host: String {
    switch self {
    case .listDailyActivity,.viewDailyActivity,.updateDailyPhotoActivity,.addDailyActivityPhotoVideo,.addNapActivity,.clssRoomCategoryList,.classroomMilestoneList,.addMedicineActivity,.addIncidentActivity,.bathRoomTypeList,.addClassRoomActivity,.addBathRoomActivity,.addMealActivity: return API.baseURL
      
    case .updateDailyActivityNap,.activityUpdate: return API.baseURL
      
    }
  }
  
  var port:Int{
    switch self {
    case .listDailyActivity,.viewDailyActivity: return API.port
    case .updateDailyPhotoActivity,.addDailyActivityPhotoVideo,.addNapActivity,.clssRoomCategoryList,.classroomMilestoneList,.addMedicineActivity,.addIncidentActivity,.bathRoomTypeList,.addClassRoomActivity,.addBathRoomActivity,.addMealActivity: return API.port
      
    case .updateDailyActivityNap,.activityUpdate: return API.port
      
    }
  }
  var path: String {
    switch self {
      
    case .listDailyActivity : return API.path + "/activity/superadmin/list"
    case .viewDailyActivity(let activity_id): return API.path + "/activity/" + "\(activity_id)"
    case .updateDailyPhotoActivity(_,_,_,_,_,_,_,let activity_id): return API.path + "/activity/superadmin/\(activity_id)/update"
    case .addDailyActivityPhotoVideo : return API.path + "/activity/teacher/add"
    case .addNapActivity,.addMedicineActivity,.addIncidentActivity,.addClassRoomActivity,.addBathRoomActivity,.addMealActivity: return API.path + "/activity/teacher/add"
    case.clssRoomCategoryList: return API.path + "/classroom/category/list"
      
    case .classroomMilestoneList: return API.path + "/classroom/milestone/list"
    case.bathRoomTypeList: return API.path + "/bathroom/type/list"
      
      
    case .updateDailyActivityNap(_,let activity_id): return API.path + "/activity/superadmin/\(activity_id)/update"
    case .activityUpdate(let id,_):return API.path + "/activity/update/" + id
      
    }
  }
  
  var method: String {
    switch self {
    case .listDailyActivity,.viewDailyActivity: return "GET"
    case .updateDailyPhotoActivity,.addDailyActivityPhotoVideo: return "POST"
    case .addNapActivity,.addMedicineActivity,.addIncidentActivity,.addClassRoomActivity,.addBathRoomActivity,.addMealActivity: return "POST"
    case .clssRoomCategoryList,.classroomMilestoneList,.bathRoomTypeList: return "GET"
    case .updateDailyActivityNap,.activityUpdate: return "POST"
      
    }
  }
  
  var parameters: [URLQueryItem]? {
    switch self {
      
    case .listDailyActivity(let classId, let sectionId,let fromDate,let toDate,let page):
      
      var  parametersArray : [URLQueryItem] = []
      if let classID = classId {
        parametersArray.append(URLQueryItem(name: "class", value: classID))
      }
      if let sectionid = sectionId {
        parametersArray.append(URLQueryItem(name: "section", value: sectionid))
      }
      if let pages = page {
        parametersArray.append(URLQueryItem(name: "page", value: pages))
      }
      if let fromDAte = fromDate {
        parametersArray.append(URLQueryItem(name: "date_from", value: fromDAte))
      }
      if let toDate = toDate {
        parametersArray.append(URLQueryItem(name: "date_to", value: toDate))
      }
      
      return parametersArray
    case .viewDailyActivity: return nil
      
    case .updateDailyPhotoActivity,.addDailyActivityPhotoVideo,.addMedicineActivity,.addIncidentActivity,.addClassRoomActivity,.addBathRoomActivity,.addMealActivity: return nil
      
    case .addNapActivity(_),.clssRoomCategoryList,.classroomMilestoneList,.bathRoomTypeList: return nil
      
    case .updateDailyActivityNap,.activityUpdate: return nil
      
    }
  }
  var headerFields: [String : String]
  {
    switch self {
    case .listDailyActivity,.viewDailyActivity,.clssRoomCategoryList,.classroomMilestoneList,.bathRoomTypeList: return ["API_VERSION" : "1.0", "DEVICE_TYPE" : "iOS"]
      
    case .updateDailyPhotoActivity,.addDailyActivityPhotoVideo,.addMedicineActivity,.addIncidentActivity,.addClassRoomActivity,.addBathRoomActivity,.addMealActivity,.activityUpdate: return ["API_VERSION" : "1.0", "DEVICE_TYPE" : "iOS","Accept":"application/json"]
      
    case .addNapActivity(_): return ["API_VERSION" : "1.0", "DEVICE_TYPE" : "iOS","Accept":"application/json"]
      
    case .updateDailyActivityNap: return ["API_VERSION" : "1.0", "DEVICE_TYPE" : "iOS","Accept":"application/json"]
      
    }
  }
  
  var body: Data? {
    switch self {
      
    case .listDailyActivity,.viewDailyActivity: return nil
      
    case .updateDailyPhotoActivity,.addDailyActivityPhotoVideo: return nil
      
    case .addNapActivity(_),.clssRoomCategoryList,.classroomMilestoneList,.addMedicineActivity,.addIncidentActivity,.bathRoomTypeList,.addClassRoomActivity,.addBathRoomActivity,.addMealActivity: return nil
      
    case .updateDailyActivityNap,.activityUpdate: return nil
      
    }
  }
  
  var formDataParameters : [String : Any]? {
    
    switch self {
      
    case .listDailyActivity,.viewDailyActivity,.clssRoomCategoryList,.classroomMilestoneList,.bathRoomTypeList: return nil
      
    case .updateDailyPhotoActivity(let state, let type, let classID, let sectionID, let Description, let studentID, let attachmet, _):
      
      let parameters = ["state" : state,
                        "type" : type,
                        "class_id" : classID,
                        "section_id" : sectionID ,
                        "description" : Description,
                        "students": studentID,
                        "attachments":attachmet
        ] as [String : Any]
      return parameters
      
    case .addDailyActivityPhotoVideo(let type, let classID, let sectionID, let Description, let studentID,let attachmet,let date):
      
      let parameters = ["type" : type,
                        "class_id" : classID,
                        "section_id" : sectionID ,
                        "description" : Description,
                        "students": studentID,
                        "attachments":attachmet,
                        "date":date
        
        ] as [String : Any]
      return parameters
      
    case .addNapActivity(let request):
      
      let parameters = ["type" : request.type,
                        "class_id" : request.class_id,
                        "section_id" : request.section_id ,
                        "description" : request.description,
                        "students": request.students,
                        "start_time": request.start_time,
                        "end_time": request.end_time,
                        "date":request.date
        
        ] as [String : Any]
      return parameters
      
    case .addMedicineActivity(let request):
      
      let parameters = ["type" : request.type,
                        "class_id" : request.class_id,
                        "section_id" : request.section_id ,
                        "description" : request.description,
                        "students": request.students,
                        "start_time": request.start_time,
                        "end_time": request.end_time,
                        "sanitizer": request.sanitizer,
                        "temperature":request.temperature,
                        "date":request.date] as [String : Any]
      return parameters
      
    case .addIncidentActivity(let request):
      
      let parameters = ["type" : request.type,
                        "class_id" : request.class_id,
                        "section_id" : request.section_id ,
                        "description" : request.description,
                        "students": request.students,
                        "start_time": request.start_time,
                        "attachments": request.attachments,
                        "end_time": request.end_time,
                        "date":request.date
        ] as [String : Any]
      return parameters
      
    case.addClassRoomActivity(let request):
      
      let parameters = ["type" : request.type,
                        "class_id" : request.class_id,
                        "section_id" : request.section_id ,
                        "description" : request.description,
                        "students": request.students,
                        "start_time": request.start_time,
                        "attachments": request.attachments,
                        "classroom_category_id": request.classroom_category_id,
                        "classroom_milestone_id": request.classroom_milestone_id,
                        "title": request.title,
                        "end_time": request.end_time,
                        "date":request.date
        
        ] as [String : Any]
      return parameters
      
    case.addBathRoomActivity(let request):
      
      let parameters = ["type" : request.type,
                        "class_id" : request.class_id,
                        "section_id" : request.section_id ,
                        "description" : request.description,
                        "students": request.students,
                        "start_time": request.start_time,
                        "bathroom_type_id": request.bathroomTypeID,
                        "diaper_change": request.disperChange,
                        "end_time": request.end_time,
                        "date":request.date
        ] as [String : Any]
      return parameters
      
    case .addMealActivity(let request):
      let parameters = ["type" : request.type,
                        "class_id" : request.class_id,
                        "section_id" : request.section_id ,
                        "description" : request.description,
                        "students": request.students,
                        "start_time": request.start_time,
                        "end_time": request.end_time,
                        "meals": request.meals,
                        "date":request.date
        ] as [String : Any]
      return parameters
    case .updateDailyActivityNap(let request,_):
      
      let parameters = ["state" : request.state,
                        "type" : request.type,
                        "class_id" : request.class_id,
                        "section_id" : request.section_id ,
                        "description" : request.description,
                        "students": request.students,
                        "start_time": request.start_time,
                        "end_time": request.end_time,
                        "bathroom_type_id":request.bathroom_type_id,
                        "diaper_change":request.diaper_change] as [String : Any]
      return parameters
      
      
    case .activityUpdate(let id,let state):
      let parameter = ["id":id,"state":state] as [String:Any]
      return parameter
      
    }
  }
}
