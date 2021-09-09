//
//  EnrolmentEnquiryViewModel.swift
//  Kinder Care
//
//  Created by CIPL0590 on 2/13/20.
//  Copyright © 2020 Athiban Ragunathan. All rights reserved.
//

import Foundation

protocol enrolmentEnquirytDelegate {
    func enrolmentList(enrolmentList : EnquiryListData?)
    func entrolmentDelete()
    func enrolmentAdd()
    func enrolmentEditSuccess()
    func getClassNameListSuccess(classList:[ClassModel])
    func failure(message : String)
    
}

class enrolmentEnquiryViewModel
{
    var delegate:enrolmentEnquirytDelegate?
    
    func classNameList( schoolId:String){
           
           AttendanceServiceHelper.request(router: AttendanceServiceManager.classNameList(_schoolId: schoolId), completion: {
               (result : Result<ClassResponse, CustomError>) in
               DispatchQueue.main.async {
                   
                   switch result {
                   case .success(let data):
                       if let _data = data.data {
                        self.delegate?.getClassNameListSuccess(classList: _data)
                       }
                   case .failure(let message): self.delegate?.failure(message: "\(message)")
                   }
               }
           })
           
       }
    
    func enrolmentList(school_id:Int,from_date:String,to_date:String) {
        
        EnrolmentEnquiryServiceHelper.requestFormData(router: EnrolmentEnquiryServiceManager.enquiryList(school_id: school_id, from_date: from_date, to_date: to_date), completion: {
            (result : Result<EnquiryList, CustomError>) in
            DispatchQueue.main.async {
                
                switch result {
                case .success(let data):
                    if let _data = data.data {
                        self.delegate?.enrolmentList(enrolmentList: _data)
                    }
                case .failure(let message): self.delegate?.failure(message: "\(message)")
                }
            }
        })
    }
    
    func enrolmentAdd(institute_id:Int,school_id:Int,student_name:String,age:Int,dob:String,class1:Int,father_name:String,mother_name:String,contact:String,email:String,purpose:String,status:Int){
        
        EnrolmentEnquiryServiceHelper.requestFormData(router: EnrolmentEnquiryServiceManager.enquiryAdd(institute_id: institute_id, school_id: school_id, student_name: student_name, age: age, dob: dob, class1: class1, father_name: father_name, mother_name: mother_name, contact: contact, email: email, purpose: purpose, status: status), completion: {
            (result : Result<EnrolmentExtra, CustomError>) in
            DispatchQueue.main.async {
                
                switch result {
                case .success:
                    self.delegate?.enrolmentAdd()
                    
                case .failure(let message): self.delegate?.failure(message: "\(message)")
                }
            }
        })
        
    }
    
    func     enrolmentEdit(listId:Int,institute_id:String,school_id:String,student_name:String,age:String,dob:String,class1:Int,father_name:String,mother_name:String,contact:String,email:String,purpose:String,status:String){
        
        EnrolmentEnquiryServiceHelper.requestFormData(router: EnrolmentEnquiryServiceManager.enquiryEdit(institute_id: institute_id, school_id: school_id, student_name: student_name, age: age, dob: dob, class1: class1, father_name: father_name, mother_name: mother_name, contact: contact, email: email, purpose: purpose, status: status,listID: listId), completion: {
            (result : Result<EnrolmentExtra, CustomError>) in
            DispatchQueue.main.async {
                
                switch result {
                case .success:
                    self.delegate?.enrolmentEditSuccess()
                    
                case .failure(let message): self.delegate?.failure(message: "\(message)")
                }
            }
        })
        
    }
    func enrolmentDelete(id:String) {
        
        EnrolmentEnquiryServiceHelper.request(router: EnrolmentEnquiryServiceManager.enquiryDelete(id: id), completion: {
            (result : Result<EnrolmentExtra, CustomError>) in
            
            DispatchQueue.main.async {
                
                switch result {
                case .success:
                    self.delegate?.entrolmentDelete()
                case .failure(let message): self.delegate?.failure(message: "\(message)")
                }
            }
        })
        
    }
}
