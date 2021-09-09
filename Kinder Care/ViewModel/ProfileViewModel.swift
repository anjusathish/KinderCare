//
//  ProfileViewModel.swift
//  Kinder Care
//
//  Created by CIPL0668 on 06/02/20.
//  Copyright © 2020 Athiban Ragunathan. All rights reserved.
//

import Foundation

protocol profileDelegate {
  func getProfileData(profileData : ProfileData)
  func failure(message : String)
  func editProfileData(message:String)
  func changePasswordSuccessfully(message:String)
    func healthStatusListSuccess(listHealth:[ListHelath])
    func healthAddSuccuess(message:String)
    func healthDeleteSuccess(message:String)
    func healthViewSuccess(viewHealth:[viewHealth])
}

class ProfileViewModel
{
  var delegate:profileDelegate!
  
  func getProfileData(userID : String){
    ProfileServiceHelper.request(router: ProfileServiceManager.getProfile(userID), completion: {
      (result : Result<ProfileResponse, CustomError>) in
      DispatchQueue.main.async {
        switch result {
        case .success(let data):
          if let _data = data.data {
            
            if let _data = data.data {
              
              UserProfile.shared.currentUser = _data
            }
            self.delegate.getProfileData(profileData:_data)
          }
        case .failure(let message): self.delegate?.failure(message: "\(message)")
        }
      }
    })
  }
  
    func EditProfileData(method : String, firstname : String, email : String, dob : String,contact : String, address : String,gender:String,instituteName:String){
    
        ProfileServiceHelper.requestFormData(router: ProfileServiceManager.editProfile(_method:method, firstname: firstname, email: email, dob: dob, contact: contact, address: address, gender: gender, instituteName: instituteName), completion: {
      (result : Result<EmptyResponse, CustomError>) in
      
      DispatchQueue.main.async {
        switch result {
        case .success:
          
            self.delegate.editProfileData(message: "Updated Successfully")
          
        case .failure(let message): self.delegate?.failure(message: "\(message)")
        }
      }
    })
  }
    func changePassword(method : String, firstname : String, email : String, old_password : String,password : String, con_password : String,dob:String,gender:String,contact:String,instituteName:String,address:
    String){
    
        ProfileServiceHelper.requestFormData(router: ProfileServiceManager.changePassword(_method: method, firstName: firstname, email: email, old_password: old_password, password: password, Con_password: con_password, dob: dob, gender: gender, contact: contact, instituteName: instituteName, address: address), completion: {
      
      (result : Result<EmptyResponse, CustomError>) in
      
      DispatchQueue.main.async {
        switch result {
        case .success:
          
            self.delegate.changePasswordSuccessfully(message: "Updated Successfully")
          
        case .failure(let message): self.delegate?.failure(message: "\(message)")
        }
      }
    })
  }
  
  func changeProfilePicture(method : String, image : UIImage ){
    
    
    
    ProfileServiceHelper.requestFormData(router: ProfileServiceManager.changeProfilePic(_method: method, profilePic: image), completion: {
      
      (result : Result<EmptyResponse, CustomError>) in
      
      DispatchQueue.main.async {
        switch result {
        case .success:
          
            self.delegate.changePasswordSuccessfully(message: "Updated Successfully")
          
        case .failure(let message): self.delegate?.failure(message: "\(message)")
        }
      }
    })
  }
    func healthStatusList(from_date : String, to_date : String ){
      
      
      
      ProfileServiceHelper.requestFormData(router: ProfileServiceManager.listHealthStatus(from_date: from_date, to_date: to_date), completion: {
        
        (result : Result<ListHelathStatus, CustomError>) in
        
        DispatchQueue.main.async {
          switch result {
          case .success(let data):
            if let _data = data.data {
            self.delegate.healthStatusListSuccess(listHealth: _data)
            }
          case .failure(let message): self.delegate?.failure(message: "\(message)")
          }
        }
      })
    }
    
    func healthAddStatus(user_id: Int, temp: String, sanitizer: String, time: String){
        
        ProfileServiceHelper.requestFormData(router: ProfileServiceManager.addHealthStatus(user_id: user_id, temp: temp, sanitizer: sanitizer, time: time), completion: {
               
               (result : Result<EmptyResponse, CustomError>) in
               
               DispatchQueue.main.async {
                 switch result {
                 case .success:
                  
                    self.delegate.healthAddSuccuess(message: "Added Successfully")
                   
                 case .failure(let message): self.delegate?.failure(message: "\(message)")
                 }
               }
             })
        
    }
    func healthDeleteStatus(id: String){
           
        ProfileServiceHelper.request(router: ProfileServiceManager.deleteHealthStatus(id: id), completion: {
                  
                  (result : Result<EmptyResponse, CustomError>) in
                  
                  DispatchQueue.main.async {
                    switch result {
                    case .success:
                     
                        self.delegate.healthDeleteSuccess(message: "Deleted Successfully")
                      
                    case .failure(let message): self.delegate?.failure(message: "\(message)")
                    }
                  }
                })
           
       }
    func viewHealthStatus(id: String,date:String){
        
        ProfileServiceHelper.requestFormData(router: ProfileServiceManager.viewHealthStatus(id: id,date:date), completion: {
               
               (result : Result<ViewHelathStatus, CustomError>) in
               
               DispatchQueue.main.async {
                 switch result {
                 case .success(let data):
                   if let _data = data.data {
                    self.delegate.healthViewSuccess(viewHealth:_data )
                    }
                 case .failure(let message): self.delegate?.failure(message: "\(message)")
                 }
               }
             })
        
    }
    
}

