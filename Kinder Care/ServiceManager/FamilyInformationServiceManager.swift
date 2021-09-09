//
//  FamilyInformationServiceManager.swift
//  Kinder Care
//
//  Created by CIPL0590 on 4/8/20.
//  Copyright © 2020 Athiban Ragunathan. All rights reserved.
//

import Foundation

enum FamilyInformationServiceManager {
    
    case familyDetail(student_id:Int)
    case editPickup(pickupID:String,pickup_person:String,relationship:String,pickup_contact:String,_method:String)
    case paymentList(studentID:String,schoolID:String)
    
    
    var scheme: String {
        switch self {
        case .familyDetail(_),.editPickup(_),.paymentList(_): return API.scheme
       
            
        }
    }
    var host: String {
        switch self {
        case .familyDetail(_),.editPickup(_),.paymentList(_) : return API.baseURL
            
        }
    }
    
    var path: String {
        switch self {
            
        case .familyDetail(_) : return API.path + "/parent/familyinformation/filter"
            
        case .editPickup(let pickupID,_,_,_,_): return API.path + "/parent/pickupperson/update/" + pickupID
            
        case .paymentList(let studentID,_) : return API.path +
            "/payment/student/\(studentID)/list"
            }
    }
    
    var method: String {
        switch self {
        case .familyDetail(_),.editPickup(_): return "POST"
        case .paymentList(_):return "GET"
        }
    }
    
    var port:Int{
        switch self {
        case .familyDetail(_),.editPickup(_),.paymentList(_): return API.port
            
        }
    }
    
    var parameters: [URLQueryItem]? {
        switch self {
        case .familyDetail(_),.editPickup(_):
            return nil
            
        case .paymentList(let studentID,let schoolID):
            return [URLQueryItem(name:"school_id",value:schoolID)]
            
        }
    }
    
    var body: Data? {
        switch self {
            
        case .familyDetail(_),.editPickup(_),.paymentList(_): return nil
            
        }
    }
    var headerFields: [String : String]
    {
        switch self {
        case .familyDetail(_),.editPickup(_),.paymentList(_):
            return ["Accept":"application/json","API_VERSION" : "1.0", "DEVICE_TYPE" : "iOS"]
            
        }
    }
    
    var formDataParameters : [String : Any]? {
        
        switch self {
        case .familyDetail(let student_id) :
            
            let parameters = ["student_id" : student_id] as [String : Any]
            return parameters
            
        case .editPickup(_,let pickup_person,let relationship,let pickup_contact,let _method) :
            
            let parameters = ["pickup_person":pickup_person,
                              "relationship":relationship,
                              "pickup_contact":pickup_contact,
                              "_method":_method]
            return parameters
            
        
        case .paymentList(_,_):
        //let parameters = ["student_id" : studentID,"school_id":schoolID] as [String : Any]
        return nil
        }
    }
}

