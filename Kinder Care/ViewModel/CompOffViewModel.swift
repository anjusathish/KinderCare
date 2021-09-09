//
//  CompOffViewModel.swift
//  Kinder Care
//
//  Created by PraveenKumar R on 18/03/21.
//  Copyright © 2021 Athiban Ragunathan. All rights reserved.
//

import Foundation
protocol CompOffApplicationDelegate {
  
  func leaveApplicationSuccess(_ compOffApplicationList: [CompOffListDatum])
  func getLeaveApprovalSuccess(_ compOffApprovalListData: [CompOffApporvalDatum])
  func addCompOffRequestSuccess(_ message: String)
  func updateCompOffApprovalSuccess(message:String)
  func deleteLeaveRequestSuccess()
  func failure(message : String)
}


class CompOffViewModel {
  
  var delegate: CompOffApplicationDelegate?
  
  
  //MARK:- AddCompOff
  func viewLeaveList(leaveReqId : String){
    
    LeaveServiceHelper.requestFormData(router: LeaveServiceManager.compoffList(requestApplyLeave: "0")) { (result : Result<CompOffApplicationListResponse,CustomError>) in
      
      DispatchQueue.main.async {
        
        switch result {
        
        case .success(let data):
          
          if let _data =  data.data {
            
            self.delegate?.leaveApplicationSuccess(_data)
            
          }
          
        case .failure(let message):
          self.delegate?.failure(message: "\(message)")
        }
      }
    }
    
  }
  
  //MARK:- AddCompOffRequest API
  func addCompOffRequest(_ applyDate: String, _ contact: String, _ reason: String) {
    
    LeaveServiceHelper.requestFormData(router: LeaveServiceManager.addCompOff(applyDate: applyDate, contact: contact, reason: reason)) { (result : Result<AddCompOffResponse,CustomError>) in
      
      DispatchQueue.main.async {
        
        switch result {
        
        case .success(let data):
          
          if let status = data.status {
            self.delegate?.addCompOffRequestSuccess(status)
          }
          
        case .failure(let message):
          self.delegate?.failure(message: "\(message)")
        }
      }
    }
  }
  
  func filterCompOffRequest(requestStatus: String, requestFromDate: String, requestToDate: String,applyLeave:String){
    
    LeaveServiceHelper.requestFormData(router: LeaveServiceManager.filterCompOffRequest(requestStatus: requestStatus, requestFromDate: requestFromDate, requestToDate: requestToDate, requestApplyLeave: applyLeave)  ) {
      
      (result : Result<CompOffApplicationListResponse,CustomError>) in
      
      DispatchQueue.main.async {
        
        switch result{
        
        case .success(let data):
          
          if let _data = data.data{
            
            self.delegate?.leaveApplicationSuccess(_data)
          }
          
        case .failure(let message):
          
          self.delegate?.failure(message: "\(message)")
        }
      }
    }
    
  }
  
  //MARK:- Delete LeaveRequest
  
  func deleteCompOffRequest(_ compOffRequestID: Int){
    
    LeaveServiceHelper.requestFormData(router: LeaveServiceManager.deleteCompOffRequest(compOffRequestID)) { (result : Result<DeleteLeaveEmptyResponse,CustomError>) in
      
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
  
  
  func getLeaveApproval(schoolID:Int,userType : Int,searchVal:String,status:String) {
    
    LeaveServiceHelper.requestFormData(router: LeaveServiceManager.getFilterCompOffApprovalList(schoolID, user_type: userType, search_val: searchVal, status: status), completion: {
      
      (result : Result<CompOffApporvalListResponse, CustomError>) in
      
      DispatchQueue.main.async {
        
        switch result {
        
        case .success(let data):
          
          if let _data = data.data {
            self.delegate?.getLeaveApprovalSuccess(_data)
            
          }
        case .failure(let message): self.delegate?.failure(message: "\(message)")
          
        }
      }
    })
  }
  
  
  func updateLeaveApproval(userID:String,status:Int){
      
    LeaveServiceHelper.requestFormData(router: LeaveServiceManager.updateCompOffApprovalAndRejected(userID, status)) { (result : Result<EmptyResponse,CustomError>) in
          DispatchQueue.main.async {
              switch result{
              case .success:
                self.delegate?.updateCompOffApprovalSuccess(message: "Updated Successfully")
                  
              case .failure(let message):
                  self.delegate?.failure(message: "\(message)")
              }
          }
      }
  }
  
}
