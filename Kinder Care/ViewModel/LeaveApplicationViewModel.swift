//
//  LeaveApplicationViewModel.swift
//  Kinder Care
//
//  Created by CIPL0651 on 02/03/20.
//  Copyright © 2020 Athiban Ragunathan. All rights reserved.
//

import Foundation


protocol leaveApplicationDelegate {
  func leaveApplicationSuccess(leaveApplication : LeaveApplicationModel)
  func addLeaveSuccess()
  func failure(message : String)
  func deleteLeaveRequestSuccess()
  func filterLeaveListData(leaveApplication : [LeaveApplicationList])
  func filterCompOffListData(leaveApplication : [CompOffListDatum])
  func viewLeaveDataSuccess(viewLeave:[LeaveApprovalList])
  func leaveTypeSuccess(leaveType:[LeaveTypeList])
}


class LeaveApplicationViewModel{
  var delegate : leaveApplicationDelegate?
  
  func leaveTypeList(){
    LeaveServiceHelper.request(router: LeaveServiceManager.getLeaveType) { (result : Result<LeaveTypeName,CustomError>) in
      DispatchQueue.main.async {
        switch result{
        
        case .success(let data):
          if let _data = data.data{
            self.delegate?.leaveTypeSuccess(leaveType: _data)
          }
          
          
          
          
        case .failure(let message):
          self.delegate?.failure(message: "\(message)")
        }
      }
    }
    
    
    
  }
  
  func leaveListApplication(){
    LeaveServiceHelper.request(router: LeaveServiceManager.leaveListApplication) { (result : Result<LeaveApplicationModel,CustomError>) in
      DispatchQueue.main.async {
        switch result{
        
        case .success(let data):
          self.delegate?.leaveApplicationSuccess(leaveApplication: data)
          
        case .failure(let message):
          self.delegate?.failure(message: "\(message)")
        }
      }
    }
    
    
    
  }
  
  func viewLeaveList(leaveReqId : String){
    
    LeaveServiceHelper.request(router: LeaveServiceManager.viewLeaveRequest(leaveReqid: leaveReqId)) { (result : Result<LeaveApprovalModel,CustomError>) in
      DispatchQueue.main.async {
        switch result
        {
        case .success(let data):
          if let _data = data.data{
            self.delegate?.viewLeaveDataSuccess(viewLeave: _data)
          }
        case .failure(let message):
          self.delegate?.failure(message: "\(message)")
        }
      }
    }
  }
  
  func addLeave(school_id : Int,from_date : String,to_date : String,leave_type : String,reason : String,contact : String,student_id: String,compoffID: String){
    
    LeaveServiceHelper.requestFormData(router: LeaveServiceManager.addLeaveRequest(school_id: school_id, from_date: from_date, to_date: to_date, leave_type: leave_type, reason: reason,contact: contact, student_id: student_id, compoffID: compoffID)) { (result : Result<AddLeaveEmptyResponse,CustomError>) in
      
      DispatchQueue.main.async {
        
        switch result{
        
        case .success(_):
          
          self.delegate?.addLeaveSuccess()
          
        case .failure(let message):
          
          self.delegate?.failure(message: "\(message)")
        }
      }
    }
  }
  
  
  //MARK:- Delete LeaveRequest
  
  func deleteLeaveRequest(_ leaveRequestID: Int){
    
    LeaveServiceHelper.requestFormData(router: LeaveServiceManager.deleteLeaveequest(leaveReqid:leaveRequestID )) { (result : Result<DeleteLeaveEmptyResponse,CustomError>) in
      
      DispatchQueue.main.async {
        
        switch result{
        
        case .success(_):
          
          self.delegate?.deleteLeaveRequestSuccess()
          
        case .failure(let message):
          
          self.delegate?.failure(message: "\(message)")
        }
      }
    }
  }
  
  //MARK:- Filter LeaveRequest API
  
  func filterLeaveRequest(requestStatus: String, requestFromDate: String, requestToDate: String,student_id:String){
    
    LeaveServiceHelper.requestFormData(router: LeaveServiceManager.filterLeaveRequest(requestStatus: requestStatus , requestFromDate: requestFromDate, requestToDate: requestToDate, student_id: student_id)  ) {
      
      (result : Result<LeaveApplicationModel,CustomError>) in
      
      DispatchQueue.main.async {
        
        switch result{
        
        case .success(let data):
          
          if let _data = data.data{
            
            self.delegate?.filterLeaveListData(leaveApplication: _data)
          }
          
        case .failure(let message):
          
          self.delegate?.failure(message: "\(message)")
        }
      }
    }
    
  }
  
  
  //MARK:- AddCompOff
  func viewCompOffDateList(){
    
    LeaveServiceHelper.requestFormData(router: LeaveServiceManager.compoffList(requestApplyLeave: "1")) { (result : Result<CompOffApplicationListResponse,CustomError>) in
      
      DispatchQueue.main.async {
        
        switch result {
        
        case .success(let data):
          
          if let _data =  data.data {
            
            self.delegate?.filterCompOffListData(leaveApplication: _data)
            
          }
          
        case .failure(let message):
          self.delegate?.failure(message: "\(message)")
        }
      }
    }
    
  }
}
