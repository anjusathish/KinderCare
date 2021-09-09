//
//  LeaveServiceManager.swift
//  Kinder Care
//
//  Created by CIPL0668 on 14/02/20.
//  Copyright © 2020 Athiban Ragunathan. All rights reserved.
//

import Foundation

enum LeaveServiceManager {
  
  case getFilterLeaveApprovalList(_ school_id:Int, user_type : Int,search_val:String,status:String)
  case updateLeaveApproval(_userID : String,status : Int, school_id : Int)
  case leaveListApplication
  case viewLeaveRequest(leaveReqid : String)
  case addLeaveRequest(school_id : Int,from_date : String,to_date : String,leave_type : String,reason : String,contact : String,student_id: String, compoffID: String)
  case deleteLeaveequest(leaveReqid : Int)
  case filterLeaveRequest(requestStatus: String, requestFromDate: String, requestToDate: String,student_id:String)
  case getLeaveType
  case compoffList (requestApplyLeave: String)
  case addCompOff(applyDate: String, contact: String, reason: String)
  case deleteCompOffRequest(_ compOffID: Int)
  case filterCompOffRequest(requestStatus: String, requestFromDate: String, requestToDate: String,requestApplyLeave:String)
  case getFilterCompOffApprovalList(_ school_id:Int, user_type : Int,search_val:String,status:String)
  case updateCompOffApprovalAndRejected(_ userID : String, _ status : Int)
  case getLeaveSummaryList
  
  
  var scheme: String {
    switch self {
    case .getFilterLeaveApprovalList,.updateLeaveApproval, .leaveListApplication,.addLeaveRequest,.deleteLeaveequest,.filterLeaveRequest,.viewLeaveRequest,.getLeaveType: return API.scheme
    case .compoffList,.addCompOff,.deleteCompOffRequest,.filterCompOffRequest: return API.scheme
      
    case .getFilterCompOffApprovalList,.updateCompOffApprovalAndRejected: return API.scheme
      
    case .getLeaveSummaryList:return API.scheme
      
    }
  }
  
  var host: String {
    switch self {
    case .getFilterLeaveApprovalList,.updateLeaveApproval, .leaveListApplication,.addLeaveRequest,.deleteLeaveequest,.filterLeaveRequest,.viewLeaveRequest,.getLeaveType : return API.baseURL
    case .compoffList,.addCompOff,.deleteCompOffRequest,.filterCompOffRequest: return API.baseURL
      
    case .getFilterCompOffApprovalList,.updateCompOffApprovalAndRejected: return API.baseURL
      
    case .getLeaveSummaryList:return API.baseURL
      
    }
  }
  
  var path: String {
    switch self {
    
    case .getFilterLeaveApprovalList : return API.path + "/superadmin/leaveapproval/filter"
    case .updateLeaveApproval(let _userID, _, _) : return API.path + "/superadmin/leaveapproval/update/" + _userID
    case .leaveListApplication: return API.path + "/admin/leaverequest/list"
      
    case .addLeaveRequest: return API.path + "/admin/leaverequest/add"
      
    case .deleteLeaveequest(let requestID): return API.path + "/admin/leaverequest/delete/" + "\(requestID)"
      
    case .filterLeaveRequest: return API.path + "/admin/leaverequest/filter"
    case .viewLeaveRequest(let id):return API.path + "/admin/leaverequest/view/" + id
      
    case .getLeaveType:return API.path + "/leaveType/list"
      
    case .compoffList: return API.path + "/compoff-list"
      
    case .addCompOff: return API.path + "/add-compoff"
      
    case .deleteCompOffRequest(let requestID): return API.path + "/compoff-delete/" + "\(requestID)"
      
    case .filterCompOffRequest: return API.path + "/compoff-list"
      
    case .getFilterCompOffApprovalList: return API.path + "/superadmin/compoff/filter"
      
    case .updateCompOffApprovalAndRejected: return API.path + "/superadmin/compoff/approval"
  
    case .getLeaveSummaryList: return API.path + "/superadmin/leave/summary"
      
      
    }
  }
  
  var method: String {
    switch self {
    case .getFilterLeaveApprovalList,.updateLeaveApproval,.addLeaveRequest: return "POST"
    case .leaveListApplication,.viewLeaveRequest,.getLeaveType: return "GET"
    case .deleteLeaveequest: return "POST"
    case .filterLeaveRequest: return "POST"
    case .compoffList,.addCompOff,.deleteCompOffRequest,.filterCompOffRequest: return "POST"
      
    case .getFilterCompOffApprovalList,.updateCompOffApprovalAndRejected: return "POST"
      
    case .getLeaveSummaryList: return "GET"
      
    }
  }
  
  var port:Int{
    switch self {
    case .getFilterLeaveApprovalList,.updateLeaveApproval,.leaveListApplication,.addLeaveRequest,.deleteLeaveequest,.filterLeaveRequest,.viewLeaveRequest,.getLeaveType: return API.port
    case .compoffList,.addCompOff,.deleteCompOffRequest,.filterCompOffRequest: return API.port
      
    case .getFilterCompOffApprovalList,.updateCompOffApprovalAndRejected: return API.port
      
    case .getLeaveSummaryList: return API.port
      
    }
  }
  var parameters: [URLQueryItem]? {
    switch self {
    case .getFilterLeaveApprovalList,.updateLeaveApproval,.leaveListApplication,.addLeaveRequest:
      return nil
    case .deleteLeaveequest,.filterLeaveRequest,.viewLeaveRequest,.getLeaveType: return nil
      
    case .compoffList,.addCompOff,.deleteCompOffRequest,.filterCompOffRequest: return nil
      
    case .getFilterCompOffApprovalList,.updateCompOffApprovalAndRejected: return nil
      
    case .getLeaveSummaryList: return nil
      
    }
  }
  
  var body: Data? {
    switch self {
    case .getFilterLeaveApprovalList,.updateLeaveApproval,.leaveListApplication,.addLeaveRequest,.deleteLeaveequest,.filterLeaveRequest,.viewLeaveRequest,.getLeaveType: return nil
    case .compoffList,.addCompOff,.deleteCompOffRequest,.filterCompOffRequest: return nil
    case .getFilterCompOffApprovalList,.updateCompOffApprovalAndRejected: return nil
      
    case .getLeaveSummaryList: return nil
      
    }
  }
  var headerFields: [String : String]
  {
    switch self {
    case .getFilterLeaveApprovalList,.updateLeaveApproval,.leaveListApplication,.addLeaveRequest,.deleteLeaveequest,.filterLeaveRequest,.viewLeaveRequest,.getLeaveType:
      return ["API_VERSION" : "1.0", "DEVICE_TYPE" : "iOS"]
      
    case .compoffList,.addCompOff,.deleteCompOffRequest,.filterCompOffRequest: return ["API_VERSION" : "1.0", "DEVICE_TYPE" : "iOS"]
      
    case .getFilterCompOffApprovalList,.updateCompOffApprovalAndRejected: return ["API_VERSION" : "1.0", "DEVICE_TYPE" : "iOS"]
      
    case .getLeaveSummaryList: return ["API_VERSION" : "1.0", "DEVICE_TYPE" : "iOS"]
      
    }
  }
  
  var formDataParameters : [String : Any]? {
    
    switch self {
    
    case .leaveListApplication,.viewLeaveRequest,.getLeaveType : return nil
    case .getFilterLeaveApprovalList(let school_id, let user_type,let searchVal,let status):
      let parameters = ["school_id" : school_id,
                        "user_type" : user_type,"searchval":searchVal,"status":status] as [String : Any]
      return parameters
    case .updateLeaveApproval( _, let status,let school_id):
      let parameters = ["status" : status,"school_id" : school_id] as [String : Any]
      return parameters
    // case .viewLeaveRequest(let leaveReqid):
    //   let parameters = ["leaveReqid" : leaveReqid] as [String : Any]
    //  return parameters
    
    case .addLeaveRequest(let school_id, let from_date, let to_date,let leave_type, let reason, let contact, let student_id, let compoffID) :
      
      let parameters = ["school_id" : school_id,
                        "from_date" : from_date,
                        "to_date" : to_date,
                        "leave_type" : leave_type,
                        "reason" : reason,
                        "contact" : contact,
                        "student_id": student_id,
                        "comp_off_id": compoffID] as [String : Any]
      
      return parameters
      
    case .deleteLeaveequest(_): return nil
      
    case .filterLeaveRequest(requestStatus: let requestStatus,requestFromDate: let requestFromDate, requestToDate: let requestToDate,let student_id):
      let parameters = ["from_date" : requestFromDate,
                        "to_date" : requestToDate,
                        "status" : requestStatus,"student_id":student_id] as [String : Any]
      return parameters
      
    case .compoffList(requestApplyLeave: let applyLeave):
      
      let parameters = ["apply_leave" : applyLeave] as [String : Any]
      print(parameters)
      return parameters
      
    case .addCompOff(applyDate: let requestApplyDate, contact: let requestContact, reason: let requestReason):
      
      let parameters = ["apply_date" : requestApplyDate,
                        "contact" : requestContact,
                        "reason" : requestReason] as [String : Any]
      print(parameters)
      return parameters
    case .deleteCompOffRequest: return nil
      
    case .filterCompOffRequest(requestStatus: let requestStatus, requestFromDate: let requestFromDate, requestToDate: let requestToDate, requestApplyLeave: let applyLeave):
      
      let parameters = ["from_date" : requestFromDate,
                        "to_date" : requestToDate,
                        "status" : requestStatus,"apply_leave":applyLeave] as [String : Any]
      return parameters
      
    case .getFilterCompOffApprovalList(let school_id, let user_type,let searchVal,let status):
      
      let parameters = ["school_id" : school_id,
                        "user_type" : user_type,"searchval":searchVal,"status":status] as [String : Any]
      return parameters
      
    case .updateCompOffApprovalAndRejected( let _userID, let status):
      
      let parameters = ["status" : status,"id" : _userID] as [String : Any]
      return parameters
      
    case .getLeaveSummaryList: return nil
      
    }
  }
}
