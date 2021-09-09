//
//  PickUpPersonViewModel.swift
//  Kinder Care
//
//  Created by CIPL0590 on 2/14/20.
//  Copyright © 2020 Athiban Ragunathan. All rights reserved.
//

import Foundation

protocol PickUpPersonDelegate {
    
    func PickUpPersonList(PickUp:[PickUpList])
    func pickUpStatus(message:String)
    func failure(message : String)
}

class PickUpPersonViewModel
{
    var delegate:PickUpPersonDelegate!
    
    func PickUpPersonList(school_id:Int){
        
        PickUpPersonServiceHelper.requestFormData(router:  PickUpPersonServiceManager.PickUpList(school_id: school_id), completion: {
            (result : Result<PickUpPersonApproval, CustomError>) in
            DispatchQueue.main.async {
                
                switch result {
                case .success(let data):
                    if let _data = data.data {
                        print(_data)
                        self.delegate.PickUpPersonList(PickUp: _data)
                        
                    }
                case .failure(let message): self.delegate?.failure(message: "\(message)")
                }
            }
        })
    }
    
      func PickUpPersonStatus(status:String,listId:String){
          
          PickUpPersonServiceHelper.requestFormData(router:  PickUpPersonServiceManager.PickUpStatus(listId: listId,status: status), completion: {
              (result : Result<EnrolmentExtra, CustomError>) in
              DispatchQueue.main.async {
                  
                  switch result {
                  case .success:
                    self.delegate.pickUpStatus(message: "Successfully Updated")
                      
                  case .failure(let message): self.delegate?.failure(message: "\(message)")
                  }
              }
          })
      }
}
