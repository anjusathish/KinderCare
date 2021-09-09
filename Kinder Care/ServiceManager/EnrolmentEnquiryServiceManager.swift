//
//  EnrolmentEnquiryServiceManager.swift
//  Kinder Care
//
//  Created by CIPL0590 on 2/13/20.
//  Copyright © 2020 Athiban Ragunathan. All rights reserved.
//

import Foundation

enum EnrolmentEnquiryServiceManager {
    
    case enquiryList(school_id:Int,from_date:String,to_date:String)
    case enquiryAdd(institute_id:Int,school_id:Int,student_name:String,age:Int,dob:String,class1:Int,father_name:String,mother_name:String,contact:String,email:String,purpose:String,status:Int)
    
    case enquiryDelete(id:String)
    
    case enquiryEdit(institute_id:String,school_id:String,student_name:String,age:String,dob:String,class1:Int,father_name:String,mother_name:String,contact:String,email:String,purpose:String,status:String,listID:Int)
    
    var scheme: String {
        switch self {
        case .enquiryList(_),.enquiryAdd(_),.enquiryDelete(_),.enquiryEdit(_): return API.scheme
            
        }
    }
    var host: String {
        switch self {
        case .enquiryList(_),.enquiryAdd(_),.enquiryDelete(_),.enquiryEdit(_) : return API.baseURL
            
        }
    }
    
    var path: String {
        switch self {
            
        case .enquiryList(_) : return API.path + "/superadmin/get_enquiry_list"
            
        case .enquiryAdd(_):return API.path + "/superadmin/enquiry_add"
            
        case .enquiryDelete(let listID):return API.path + "/superadmin/enquiry_delete/" + listID
        case .enquiryEdit(_,_,_,_,_,_,_,_,_,_,_,_,let listID):return API.path + "/superadmin/enquiry_update/" + "\(listID)"
            
            
        }
    }
    
    var method: String {
        switch self {
        case .enquiryList(_): return "POST"
        case .enquiryAdd(_):return "POST"
        case .enquiryDelete(_):return "GET"
        case .enquiryEdit(_):return "POST"
            
        }
    }
    var port:Int{
        switch self {
        case .enquiryList(_),.enquiryAdd(_),.enquiryDelete(_),.enquiryEdit(_): return API.port
            
        }
    }
    var parameters: [URLQueryItem]? {
        switch self {
        case .enquiryList(_),.enquiryAdd(_),.enquiryDelete(_),.enquiryEdit(_):
            return nil
            
            
        }
    }
    
    var body: Data? {
        switch self {
            
        case .enquiryList(_),.enquiryAdd(_),.enquiryDelete(_),.enquiryEdit(_): return nil
            
        }
    }
    var headerFields: [String : String]
    {
        switch self {
        case .enquiryList(_),.enquiryAdd(_),.enquiryDelete(_),.enquiryEdit(_):
            return ["Accept":"application/json","API_VERSION" : "1.0", "DEVICE_TYPE" : "iOS"]
            
        }
    }
    
    var formDataParameters : [String : Any]? {
        
        switch self {
        case .enquiryList(let school_id, let from_date,let to_date) :
            
            let parameters = ["school_id" : school_id,
                              "from_date" : from_date,"to_date":to_date] as [String : Any]
            return parameters
            
        case .enquiryAdd(let institute_id, let school_id, let student_name, let age, let dob, let class1, let father_name, let mother_name, let contact, let email, let purpose, let status):
            
            let parameters = ["institute_id":institute_id,
                              "school_id":school_id,
                              "student_name":student_name,
                              "age":age,
                              "dob": dob, "class":class1,
                              "father_name":father_name,
                              "mother_name":mother_name,
                              "contact":contact,
                              "email":email,
                              "purpose":purpose,
                              "status":status] as [String : Any]
            return parameters
            
        case .enquiryEdit(let institute_id, let school_id, let student_name, let age, let dob, let class1, let father_name, let mother_name, let contact, let email, let purpose, let status, _):
            
            let parameters = ["institute_id":institute_id,
                              "school_id":school_id,
                              "student_name":student_name,
                              "age":age,
                              "dob": dob, "class":class1,
                              "father_name":father_name,
                              "mother_name":mother_name,
                              "contact":contact,
                              "email":email,
                              "purpose":purpose,
                              "status":status] as [String : Any]
            return parameters
            
        case .enquiryDelete(_):
            return nil
        }
    }
}

