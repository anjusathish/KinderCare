//
//  LoginViewModel.swift
//  Kinder Care
//
//  Created by CIPL0681 on 04/12/19.
//  Copyright © 2019 Athiban Ragunathan. All rights reserved.
//

import Foundation

enum UserType: Int {
  
  case parent = 5
  case teacher = 4
  case admin = 3
  case superadmin = 2
  case all = 1
  case student = 6
  
  var stringValue : String {
    switch self {
    case .parent:
      return "Parent"
    case .teacher:
      return "Teacher"
    case .admin:
      return "Admin"
    case .superadmin:
      return "Super Admin"
    case .all:
      return "All"
    case .student:
      return "Student"
    }
  }
  
  var messageTitles : String {
    switch self {
      
    case .parent:
      return "All,Super Admin,Admin,Teacher"
    case .teacher:
      return "All,Admin,Super Admin"
    case .admin:
      return "All,Super Admin,Teacher"
    case .superadmin:
      return "All,Admin,Teacher,Parent"
    case .all,.student:
      return ""
    }
  }
  
  var leaveApprovalTitles : String {
    switch self {
    case .admin:
      return "Teacher,Students"
    case .superadmin:
      return "Admin,Teacher,Students"
    case .all,.student,.teacher,.parent:
      return ""
    }
  }
  
  var compOffApprovalTitles : String {
    switch self {
    case .admin:
      return "Teacher"
    case .superadmin:
      return "Admin,Teacher"
    case .all,.student,.teacher,.parent:
      return ""
    }
  }
  
  var attendanceTitles : String {
    switch self {
    case .admin:
      return "Teacher,Students"
    case .superadmin:
      return "Admin,Teacher,Students"
    case .all,.parent,.teacher,.student:
      return ""
    }
  }
  
  var reportTitles : String {
    switch self {
    case .admin:
        return "Attendance,Salary"
    //  return "Attendance"
    case .superadmin:
      return "Attendance,Salary"
    case .all,.parent,.teacher,.student:
      return ""
    }
  }
}

enum UserTypeTitle: String {
  
  case parent = "Parent"
  case teacher = "Teacher"
  case admin = "Admin"
  case superadmin = "Super Admin"
  case all = "All"
  case student = "Students"
  
  var id : Int {
    switch self {
    case .parent:
      return 5
    case .teacher:
      return 4
    case .admin:
      return 3
    case .superadmin:
      return 2
    case .all:
      return 1
    case .student:
      return 6
    }
  }
}

protocol loginDelegate {
  func loginSuccessfull(message : String)

  func failure(message : String)
}

class LoginViewModel {
  var delegate : loginDelegate!
  
  func loginUser(email : String, password : String, remember_me : Int) {
    OnBoardingServiceHelper.requestFormData(router: OnBoardingServiceManager.login(email, password: password, rememberMe: remember_me), completion: { (result : Result<UserDetails, CustomError>) in
      
      DispatchQueue.main.async {
        switch result {
        case .success(let data):
          
          UserManager.shared.currentUser = data
          
          if let _userid = data.userID {
            
            self.getProfileData(userID:"\(_userid)")
          }
          
          self.delegate.loginSuccessfull(message: "Logged In Successfully")
          
        case .failure(let message): self.delegate?.failure(message: "\(message)")
          
        }
      }
    })
  }
  
}

//MARK:- GetProfileData
extension LoginViewModel{
  
  func getProfileData(userID : String){
    
    ProfileServiceHelper.request(router: ProfileServiceManager.getProfile(userID), completion: {
      
      (result : Result<ProfileResponse, CustomError>) in
      DispatchQueue.main.async {
        
        switch result {
        case .success(let data):
          
          if let _data = data.data {
            
            UserProfile.shared.currentUser = _data
          }
        case .failure(let message): self.delegate?.failure(message: "\(message)")
          
        }
      }
    })
  }
}
