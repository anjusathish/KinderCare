//
//  LeaveApprovalViewModel.swift
//  Kinder Care
//
//  Created by CIPL0668 on 14/02/20.
//  Copyright © 2020 Athiban Ragunathan. All rights reserved.
//

import Foundation

protocol  leaveApprovalDelegate {
  func getLeaveApprovalSuccess(leaveData : LeaveApprovalModel)
  func updateLeaveApprovalSuccess(message:String)
  func getLeaveSummaryData(_ leaveSummaryList: [LeaveSummaryDatum])
  func failure(message : String)
}


class LeaveApprovalViewModel {
  var delegate : leaveApprovalDelegate?
  
  func getLeaveApproval(schoolID:Int,userType : Int,searchVal:String,status:String)
  {
    LeaveServiceHelper.requestFormData(router: LeaveServiceManager.getFilterLeaveApprovalList(schoolID, user_type: userType, search_val: searchVal, status: status), completion: {
      (result : Result<LeaveApprovalModel, CustomError>) in
      DispatchQueue.main.async {
        switch result {
        case .success(let data):
          
          self.delegate?.getLeaveApprovalSuccess(leaveData:data)
          
        case .failure(let message): self.delegate?.failure(message: "\(message)")
        }
      }
    })
    
  }
  
  
  //Update Approval..
  func updateLeaveApproval(userID:String,status:Int,school_id:Int){
    
    LeaveServiceHelper.requestFormData(router: LeaveServiceManager.updateLeaveApproval(_userID: userID, status: status, school_id: school_id)) { (result : Result<EmptyResponse,CustomError>) in
      DispatchQueue.main.async {
        switch result{
        case .success:
          self.delegate?.updateLeaveApprovalSuccess(message: "Updated Successfully")
          
        case .failure(let message):
          self.delegate?.failure(message: "\(message)")
        }
      }
    }
  }
  
  func getLeaveSummaryList() {
    
    LeaveServiceHelper.request(router: LeaveServiceManager.getLeaveSummaryList, completion: {
      (result : Result<LeaveSummaryListResponse, CustomError>) in
      
      DispatchQueue.main.async {
        
        switch result {
        
        case .success(let data):
          
          if let _data = data.data {
            
            self.delegate?.getLeaveSummaryData(_data)
          }
          
        case .failure(let message): self.delegate?.failure(message: "\(message)")
          
        }
      }
    })
  }
  
}
