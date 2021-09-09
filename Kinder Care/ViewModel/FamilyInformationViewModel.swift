//
//  FamilyInformationViewModel.swift
//  Kinder Care
//
//  Created by CIPL0590 on 4/8/20.
//  Copyright © 2020 Athiban Ragunathan. All rights reserved.
//

import Foundation

protocol familyInformationDelegate {
    func familyDetailsList(familyDetails : FamilyInformationData?)
    func editPickupSuccess()
    func failure(message : String)
    func paymentList(paymentList:[PaymentListData])
    }

class familyInformationViewModel
{
    var delegate:familyInformationDelegate?
    
    func familyDetail(student_id:Int){
           
        FamilyInformationServiceHelper.requestFormData(router: FamilyInformationServiceManager.familyDetail(student_id: student_id), completion: {
               (result : Result<FamilyInformation, CustomError>) in
               DispatchQueue.main.async {
                   
                   switch result {
                   case .success(let data):
                       if let _data = data.data {
                        self.delegate?.familyDetailsList(familyDetails: _data)
                       }
                   case .failure(let message): self.delegate?.failure(message: "\(message)")
                   }
               }
           })
           
       }
    func editPickUpDetails(pickup_person:String,relationship:String,pickup_contact:String,_method:String,pickupId:String){
        
        FamilyInformationServiceHelper.requestFormData(router: FamilyInformationServiceManager.editPickup(pickupID: pickupId, pickup_person: pickup_person, relationship: relationship, pickup_contact: pickup_contact, _method: _method), completion: {
            (result : Result<EmptyResponse, CustomError>) in
            DispatchQueue.main.async {
                
                switch result {
                case .success:
                    self.delegate?.editPickupSuccess()
                    
                case .failure(let message): self.delegate?.failure(message: "\(message)")
                }
            }
        })
        
    }
    func paymentList(student_id:String,school_id:String){
        
        FamilyInformationServiceHelper.request(router: FamilyInformationServiceManager.paymentList(studentID: student_id, schoolID: school_id), completion: {
            (result : Result<PaymentList, CustomError>) in
            DispatchQueue.main.async {
                
                switch result {
                case .success(let data):
                    if let _data = data.data {
                     self.delegate?.paymentList(paymentList:_data)
                    }
                case .failure(let message): self.delegate?.failure(message: "\(message)")
                }
            }
        })
        
    }
    
    
    
    
    
}
