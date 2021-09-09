//
//  AddWeeklyMenuViewModel.swift
//  Kinder Care
//
//  Created by Athiban Ragunathan on 18/03/20.
//  Copyright © 2020 Athiban Ragunathan. All rights reserved.
//

import Foundation

protocol AddWeeklyMenuDelegate {
    
    func success(message:String)
    func failure(message : String)
}

class AddWeeklyMenuViewModel
{
    var delegate:AddWeeklyMenuDelegate!
    
//    func addMenu(forSchool schoolId : Int, date : String, menu : [Menu], classId : Int, studentIds : [String], teacherIds : [String]) {
//
//        let request = AddMenuRequest(schoolID: "\(schoolId)", date: date, data: menu, classID: "\(classId)", studentID: studentIds, teacherID: teacherIds)
//
//        WeeklyMenuServiceHelper.request(router: .addWeeklyMenu(request: request), completion: {
//            (result : Result<EmptyResponse, CustomError>) in
//            DispatchQueue.main.async {
//
//                switch result {
//                case .success: self.delegate.success(message: "")
//                case .failure(let message): self.delegate?.failure(message: "\(message)")
//                }
//            }
//        })
//    }
  
  func addMenu(request: AddWeeklyMenuRequest) {
            
      WeeklyMenuServiceHelper.request(router: .addWeeklyMenu(request: request), completion: {
          (result : Result<EmptyResponse, CustomError>) in
          DispatchQueue.main.async {
              
              switch result {
              case .success: self.delegate.success(message: "")
              case .failure(let message): self.delegate?.failure(message: "\(message)")
              }
          }
      })
  }
  
  func editWeeklyMenu(request: AddWeeklyMenuRequest, _ weeklyMenuID: String) {
            print(weeklyMenuID)
    WeeklyMenuServiceHelper.request(router: .editWeeklyMenu(request: request, weeklyMenuID), completion: {
          (result : Result<EmptyResponse, CustomError>) in
          DispatchQueue.main.async {
              
              switch result {
              case .success: self.delegate.success(message: "")
              case .failure(let message): self.delegate?.failure(message: "\(message)")
              }
          }
      })
  }
  
}
