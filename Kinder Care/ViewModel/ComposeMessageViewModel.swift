//
//  ComposeMessageViewModel.swift
//  Kinder Care
//
//  Created by CIPL0419 on 26/02/20.
//  Copyright © 2020 Athiban Ragunathan. All rights reserved.
//

import Foundation

protocol composeMessageDelegate {
    func messageUserListSuccessfull(messageData : [MessageUserData]?)
    func getStudentListSuccessfull(studentList : [Student])
    func getTeacherListSuccessfull(teacherList:[TeacherListData])
    func failure(message : String)
}

class ComposeMessageViewModel  {
  
  var delegate : composeMessageDelegate?
  
  func getUserList(search_user : String, send_to:[Int],school_id : Int,classID:String,sectionID:String) {
    
    MessageServiceHelper.requestFormData(router: MessageServiceManager.messageUserList(search_user: search_user, send_to: send_to, school_id: school_id, classID: classID, sectionID: sectionID), completion: {
      
      (result : Result<MessageUserList, CustomError>) in
      
      DispatchQueue.main.async {
        
        switch result {
          
        case .success(let data):
          
          self.delegate?.messageUserListSuccessfull(messageData: data.data)
          
        case .failure(let message): self.delegate?.failure(message: "\(message)")
        }
      }
    })
  }
  
  func getStudentList(search_user: String,schoolId : Int,classID: String,sectionID : String) {
    
    MessageServiceHelper.request(router: .getStudentList(search_user: search_user, schoolId: schoolId, classID: classID, sectionID: sectionID), completion: {
      
      (result : Result<StudentListResponse, CustomError>) in
      
      DispatchQueue.main.async {
        
        switch result {
          
        case .success(let data):
          
          self.delegate?.getStudentListSuccessfull(studentList: data.data)
          
        case .failure(let message): self.delegate?.failure(message: "\(message)")
        }
      }
    })
  }
  
  func getTeacherList(schoolId : Int) {
    
    MessageServiceHelper.request(router: .getTeacherList(schoolID: schoolId), completion: {
      
      (result : Result<TeacherList, CustomError>) in
      
      DispatchQueue.main.async {
        
        switch result {
          
        case .success(let data):
          
          self.delegate?.getTeacherListSuccessfull(teacherList: data.data)
          
        case .failure(let message): self.delegate?.failure(message: "\(message)")
        }
      }
    })
  }
}
